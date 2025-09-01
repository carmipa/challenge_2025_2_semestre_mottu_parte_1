package br.com.fiap.mottu.service.ocr;

import net.sourceforge.tess4j.ITessAPI;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Rect;
import org.opencv.objdetect.CascadeClassifier;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static br.com.fiap.mottu.service.ocr.ImageCVUtils.bufferedToMat;

@Service
public class TesseractService {

    private static final Logger log = LoggerFactory.getLogger(TesseractService.class);

    // ======= CONSTANTES DE OCR =======
    private static final String TEMP_DIR_NAME = "mottu_tesseract";         // SEM subpasta "tessdata"
    private static final String[] LANG_FILES = {"por.traineddata", "eng.traineddata"};
    private static final String LANGS = "por+eng";                          // use apenas "por" se quiser

    // regex para placas BR
    private static final Pattern PLACA_MERCOSUL = Pattern.compile("[A-Z]{3}\\d[A-Z]\\d{2}");
    private static final Pattern PLACA_ANTIGA   = Pattern.compile("[A-Z]{3}\\d{4}");

    /**
     * Ponto de entrada: recebe imagem, detecta placa, pré-processa, roda OCR e normaliza.
     */
    public String recognizePlate(MultipartFile imageFile) throws TesseractException, IOException {
        Tesseract tess = buildTesseractInstance();

        BufferedImage original = ImageIO.read(imageFile.getInputStream());
        if (original == null) {
            throw new IOException("Não foi possível ler a imagem enviada.");
        }

        // 1) tentar detectar a região da placa (se OpenCV estiver ok)
        BufferedImage plateRoi = tryDetectPlate(original);

        // 2) pré-processar ROI
        BufferedImage pre = preprocessForOcr(plateRoi);

        // 3) OCR com PSMs adequados
        tess.setPageSegMode(ITessAPI.TessPageSegMode.PSM_SINGLE_LINE);
        String raw = safeDoOcr(tess, pre);
        if (isInvalid(raw)) {
            log.warn("Primeira passada PSM_SINGLE_LINE retornou vazio. Tentando PSM_SINGLE_BLOCK...");
            tess.setPageSegMode(ITessAPI.TessPageSegMode.PSM_SINGLE_BLOCK);
            raw = safeDoOcr(tess, pre);
        }

        log.info("Resultado bruto do OCR: '{}'", raw);

        // 4) Normalização/validação para placa BR
        String placa = pickBrazilPlate(raw);
        if (placa.isEmpty()) {
            throw new TesseractException("Não foi possível reconhecer uma placa válida.");
        }

        return placa;
    }

    // ======= PREPARO DO TESSERACT =======

    /**
     * Cria instância do Tesseract apontando para a PASTA TEMP que contém .traineddata (sem subpasta).
     * Também seta TESSDATA_PREFIX para evitar inconsistências de caminho.
     */
    private Tesseract buildTesseractInstance() throws IOException {
        File langDir = ensureLangFilesInTemp();

        Tesseract t = new Tesseract();
        String dp = langDir.getAbsolutePath();

        // datapath e TESSDATA_PREFIX apontando para a pasta que CONTÉM os .traineddata
        t.setDatapath(dp);
        t.setVariable("TESSDATA_PREFIX", dp + File.separator);

        t.setLanguage(LANGS);
        t.setOcrEngineMode(ITessAPI.TessOcrEngineMode.OEM_LSTM_ONLY);
        t.setVariable("user_defined_dpi", "300");
        t.setVariable("tessedit_char_whitelist", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
        return t;
    }

    /**
     * Garante que os arquivos de idioma dentro de src/main/resources/tessdata
     * sejam extraídos para %TEMP%/mottu_tesseract (sem subpasta).
     */
    private File ensureLangFilesInTemp() throws IOException {
        File base = new File(System.getProperty("java.io.tmpdir"), TEMP_DIR_NAME);
        if (!base.exists() && !base.mkdirs()) {
            throw new IOException("Não foi possível criar diretório temporário: " + base.getAbsolutePath());
        }

        for (String file : LANG_FILES) {
            File out = new File(base, file);
            if (!out.exists()) {
                String resourcePath = "/tessdata/" + file;
                try (InputStream in = getClass().getResourceAsStream(resourcePath)) {
                    if (in == null) {
                        throw new IOException("Recurso não encontrado: " + resourcePath +
                                " (coloque seus .traineddata em src/main/resources/tessdata/)");
                    }
                    try (OutputStream os = Files.newOutputStream(out.toPath())) {
                        FileCopyUtils.copy(in, os);
                    }
                }
                log.info("Idioma '{}' copiado para {}", file, out.getAbsolutePath());
            }
        }

        return base;
    }

    // ======= DETECÇÃO DE PLACA (OPENCV) =======

    /**
     * Tenta detectar a placa usando o cascade dos resources.
     * Se algo falhar, retorna a imagem original (fail-safe).
     */
    private BufferedImage tryDetectPlate(BufferedImage source) {
        try {
            // carrega o cascade de resources para arquivo temporário
            String resource = "/classifiers/haarcascade_russian_plate_number.xml";
            InputStream in = getClass().getResourceAsStream(resource);
            if (in == null) {
                log.warn("Cascade XML não encontrado em {}. Seguindo sem recorte de placa.", resource);
                return source;
            }
            File tmp = File.createTempFile("cascade", ".xml");
            try (in; OutputStream os = new FileOutputStream(tmp)) {
                in.transferTo(os);
            }

            CascadeClassifier cc = new CascadeClassifier(tmp.getAbsolutePath());
            if (cc.empty()) {
                log.warn("CascadeClassifier vazio. Seguindo sem recorte.");
                return source;
            }

            Mat mat = bufferedToMat(source);
            MatOfRect rects = new MatOfRect();
            cc.detectMultiScale(mat, rects);

            Rect[] arr = rects.toArray();
            if (arr.length == 0) {
                log.info("Nenhuma placa detectada. Usando imagem completa.");
                return source;
            }

            // usa a primeira região detectada
            Rect r = arr[0];
            int x = Math.max(0, r.x);
            int y = Math.max(0, r.y);
            int w = Math.min(r.width, source.getWidth() - x);
            int h = Math.min(r.height, source.getHeight() - y);

            BufferedImage roi = source.getSubimage(x, y, w, h);
            log.info("Placa detectada em x={}, y={}, w={}, h={}", x, y, w, h);
            return roi;
        } catch (Throwable t) {
            log.debug("Detecção de placa ignorada ({})", t.toString());
            return source;
        }
    }

    // ======= PRÉ-PROCESSAMENTO =======

    private BufferedImage preprocessForOcr(BufferedImage src) {
        // escala de cinza
        BufferedImage gray = new BufferedImage(src.getWidth(), src.getHeight(), BufferedImage.TYPE_BYTE_GRAY);
        Graphics2D g = gray.createGraphics();
        g.drawImage(src, 0, 0, null);
        g.dispose();

        // upscale se muito pequena
        final int MIN_W = 300;
        BufferedImage scaled = gray;
        if (gray.getWidth() < MIN_W) {
            double scale = (double) MIN_W / gray.getWidth();
            int nw = (int) (gray.getWidth() * scale);
            int nh = (int) (gray.getHeight() * scale);
            scaled = resize(gray, nw, nh);
        }

        // binarização "rápida" (desenho simples em imagem TYPE_BYTE_BINARY)
        BufferedImage binary = new BufferedImage(scaled.getWidth(), scaled.getHeight(), BufferedImage.TYPE_BYTE_BINARY);
        Graphics2D g2 = binary.createGraphics();
        g2.drawImage(scaled, 0, 0, null);
        g2.dispose();

        return binary;
    }

    private BufferedImage resize(BufferedImage img, int w, int h) {
        BufferedImage out = new BufferedImage(w, h, img.getType());
        Graphics2D g2 = out.createGraphics();
        g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2.drawImage(img, 0, 0, w, h, null);
        g2.dispose();
        return out;
    }

    // ======= OCR SAFE =======

    private String safeDoOcr(Tesseract t, BufferedImage img) {
        try {
            return t.doOCR(img);
        } catch (TesseractException e) {
            log.warn("Uma passada de OCR falhou: {}", e.getMessage());
            return "";
        }
    }

    private boolean isInvalid(String s) {
        return s == null || s.trim().isEmpty();
    }

    // ======= NORMALIZAÇÃO PARA PLACA BR =======

    private String pickBrazilPlate(String raw) {
        if (raw == null) return "";

        String cleaned = raw.replaceAll("[^A-Za-z0-9]", "").toUpperCase();

        // correções comuns O/0, I/L/1, S/5, B/8, Q/0
        cleaned = cleaned
                .replace('Ø', '0')
                .replace('O', '0')
                .replace('Q', '0')
                .replace('I', '1')
                .replace('L', '1')
                .replace('S', '5')
                .replace('B', '8');

        Matcher m1 = PLACA_MERCOSUL.matcher(cleaned);
        if (m1.find()) return m1.group();

        Matcher m2 = PLACA_ANTIGA.matcher(cleaned);
        if (m2.find()) return m2.group();

        // última tentativa: procurar janela deslizante de 7 caracteres alfanuméricos
        for (int i = 0; i + 7 <= cleaned.length(); i++) {
            String w = cleaned.substring(i, i + 7);
            if (PLACA_MERCOSUL.matcher(w).matches() || PLACA_ANTIGA.matcher(w).matches()) {
                return w;
            }
        }
        return "";
    }
}
