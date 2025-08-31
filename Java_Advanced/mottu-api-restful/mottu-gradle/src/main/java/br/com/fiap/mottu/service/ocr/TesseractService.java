package br.com.fiap.mottu.service.ocr;

import net.sourceforge.tess4j.ITessAPI;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

@Service
public class TesseractService {

    private static final Logger log = LoggerFactory.getLogger(TesseractService.class);

    // pastas/arquivos do tessdata
    private static final String TESS_DATA_PARENT_DIR_NAME = "mottu_tesseract";
    private static final String TESS_DATA_SUBDIR_NAME = "tessdata";
    private static final String LANG_FILE_NAME = "por.traineddata";
    private static final String LANG_CODE = "por";

    // ——————————————————— PUBLIC API ———————————————————

    public String recognizePlate(MultipartFile imageFile) throws TesseractException, IOException {
        Tesseract tess = buildTesseract();

        log.info("Iniciando reconhecimento de OCR...");
        BufferedImage original = ImageIO.read(imageFile.getInputStream());
        if (original == null) throw new IOException("Não foi possível ler o arquivo de imagem.");

        BufferedImage pre = preprocess(original);

        // 1ª passada: PSM 7 (linha única) — bom para placas já recortadas
        tess.setPageSegMode(ITessAPI.TessPageSegMode.PSM_SINGLE_LINE);
        String raw = safeDoOcr(tess, pre);

        if (isBlank(raw)) {
            // 2ª passada: PSM 6 (bloco de texto uniforme) — quando a placa está no meio de ruído
            tess.setPageSegMode(ITessAPI.TessPageSegMode.PSM_SINGLE_BLOCK);
            raw = safeDoOcr(tess, pre);
        }

        log.info("Resultado bruto do OCR: {}", raw);

        String normalized = normalizePlate(raw);
        if (normalized.isEmpty()) {
            throw new TesseractException("Não foi possível reconhecer uma placa válida. Resultado: " + (raw == null ? "" : raw));
        }
        return normalized;
    }

    // ——————————————————— TESSERACT SETUP ———————————————————

    private Tesseract buildTesseract() throws IOException {
        File tessdataDir = ensureTessdata();

        Tesseract tess = new Tesseract();
        tess.setDatapath(tessdataDir.getAbsolutePath());

        // ajuda a evitar “Invalid resolution 1 dpi”
        tess.setVariable("user_defined_dpi", "300");

        // engine LSTM
        tess.setOcrEngineMode(ITessAPI.TessOcrEngineMode.OEM_LSTM_ONLY);

        // PT-BR (para dígitos/letras tanto faz; mantém por consistência)
        tess.setLanguage(LANG_CODE);

        // restringe o alfabeto a letras e números (placas)
        tess.setVariable("tessedit_char_whitelist", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");

        return tess;
    }

    /**
     * Garante %TMP%/mottu_tesseract/tessdata com por.traineddata dentro.
     * Retorna o diretório "tessdata".
     */
    private File ensureTessdata() throws IOException {
        File base = new File(System.getProperty("java.io.tmpdir"), TESS_DATA_PARENT_DIR_NAME);
        if (!base.exists() && !base.mkdir()) {
            throw new IOException("Não foi possível criar diretório: " + base.getAbsolutePath());
        }

        File tessdata = new File(base, TESS_DATA_SUBDIR_NAME);
        if (!tessdata.exists() && !tessdata.mkdir()) {
            throw new IOException("Não foi possível criar diretório: " + tessdata.getAbsolutePath());
        }

        File lang = new File(tessdata, LANG_FILE_NAME);
        if (!lang.exists()) {
            log.info("Extraindo '{}' para: {}", LANG_FILE_NAME, lang.getAbsolutePath());
            try (InputStream in = getClass().getResourceAsStream("/tessdata/" + LANG_FILE_NAME)) {
                if (in == null) {
                    throw new IOException("Recurso /tessdata/" + LANG_FILE_NAME + " não encontrado. " +
                            "Coloque-o em src/main/resources/tessdata/");
                }
                try (OutputStream out = new FileOutputStream(lang)) {
                    FileCopyUtils.copy(in, out);
                }
            }
            log.info("Arquivo '{}' copiado com sucesso.", LANG_FILE_NAME);
        }

        return tessdata;
    }

    // ——————————————————— PREPROCESSING ———————————————————

    private BufferedImage preprocess(BufferedImage src) {
        // 1) Grayscale
        BufferedImage gray = new BufferedImage(src.getWidth(), src.getHeight(), BufferedImage.TYPE_BYTE_GRAY);
        Graphics2D g = gray.createGraphics();
        g.drawImage(src, 0, 0, null);
        g.dispose();

        // 2) Upscale se pequeno (evita “too small to scale”)
        int minTargetWidth = 600; // heurística simples
        double scale = gray.getWidth() < minTargetWidth ? (minTargetWidth / (double) gray.getWidth()) : 1.0;
        BufferedImage scaled = (scale > 1.0) ? resize(gray, (int) Math.round(gray.getWidth() * scale),
                (int) Math.round(gray.getHeight() * scale)) : gray;

        // 3) Binarização (limiar simples/rápido; suficiente p/ placas de alto contraste)
        BufferedImage bin = new BufferedImage(scaled.getWidth(), scaled.getHeight(), BufferedImage.TYPE_BYTE_BINARY);
        Graphics2D g2 = bin.createGraphics();
        g2.drawImage(scaled, 0, 0, null);
        g2.dispose();

        return bin;
    }

    private BufferedImage resize(BufferedImage src, int w, int h) {
        BufferedImage out = new BufferedImage(w, h, src.getType());
        Graphics2D g2d = out.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.drawImage(src, 0, 0, w, h, null);
        g2d.dispose();
        return out;
    }

    // ——————————————————— HELPERS ———————————————————

    private String safeDoOcr(Tesseract tess, BufferedImage img) {
        try {
            return tess.doOCR(img);
        } catch (TesseractException e) {
            log.warn("Falha na passada de OCR: {}", e.getMessage());
            return "";
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Normaliza para somente [A-Z0-9], uppercase.
     * (Se quiser validar padrão Mercosul BR, dá pra aplicar regex aqui.)
     */
    private String normalizePlate(String raw) {
        if (raw == null) return "";
        String cleaned = raw.replaceAll("[^A-Za-z0-9]", "").toUpperCase();
        // Heurística mínima: geralmente placas têm 6–7 chars
        if (cleaned.length() < 5) return "";
        return cleaned;
    }
}
