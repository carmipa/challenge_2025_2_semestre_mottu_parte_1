package br.com.fiap.mottu.service.ocr;

import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@Service
public class TesseractService {

    private static final Logger log = LoggerFactory.getLogger(TesseractService.class);
    private static final String TESS_DATA_PARENT_DIR_NAME = "mottu_tesseract";
    private static final String TESS_DATA_SUBDIR_NAME = "tessdata";

    private Tesseract getTesseractInstance() throws IOException {
        Tesseract tesseract = new Tesseract();

        // --- SOLUÇÃO DEFINITIVA E ROBUSTA ---
        // Cria uma estrutura de diretórios temporária isolada e previsível
        // para garantir que o Tesseract encontre os seus ficheiros de dados.
        File tessDataParentDir = prepareTessDataDirectory();
        tesseract.setDatapath(tessDataParentDir.getAbsolutePath());

        tesseract.setLanguage("por"); // Língua portuguesa
        tesseract.setVariable("tessedit_char_whitelist", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
        return tesseract;
    }

    public String recognizePlate(MultipartFile imageFile) throws TesseractException, IOException {
        Tesseract tesseract = getTesseractInstance();

        log.info("Iniciando reconhecimento de OCR...");
        BufferedImage bufferedImage = ImageIO.read(imageFile.getInputStream());
        if (bufferedImage == null) {
            throw new IOException("Não foi possível ler o arquivo de imagem.");
        }

        String result = tesseract.doOCR(bufferedImage);
        log.info("Resultado bruto do OCR: {}", result);

        return result.replaceAll("[^A-Z0-9]", "").trim().toUpperCase();
    }

    /**
     * Prepara um diretório temporário para os dados do Tesseract.
     * Cria a estrutura /temp/mottu_tesseract/tessdata/ e copia o
     * ficheiro por.traineddata para lá, se ainda não existir.
     * @return O diretório pai ('mottu_tesseract'), que será usado no setDatapath.
     * @throws IOException se houver falha na criação de diretórios ou na cópia do ficheiro.
     */
    private File prepareTessDataDirectory() throws IOException {
        try {
            File tempDir = new File(System.getProperty("java.io.tmpdir"), TESS_DATA_PARENT_DIR_NAME);
            if (!tempDir.exists()) {
                tempDir.mkdir();
            }

            File tessdataSubDir = new File(tempDir, TESS_DATA_SUBDIR_NAME);
            if (!tessdataSubDir.exists()) {
                tessdataSubDir.mkdir();
            }

            String langFileName = "por.traineddata";
            File languageFile = new File(tessdataSubDir, langFileName);

            if (!languageFile.exists()) {
                log.info("Extraindo o ficheiro '{}' para o diretório temporário: {}", langFileName, languageFile.getAbsolutePath());
                InputStream in = getClass().getResourceAsStream("/tessdata/" + langFileName);
                if (in == null) {
                    throw new IOException("Não foi possível encontrar o ficheiro /tessdata/" + langFileName + " nos recursos do projeto.");
                }
                try (OutputStream out = new FileOutputStream(languageFile)) {
                    FileCopyUtils.copy(in, out);
                }
                log.info("Ficheiro extraído com sucesso.");
            }

            return tempDir; // Retorna o diretório PAI que contém a pasta 'tessdata'

        } catch (Exception e) {
            log.error("Ocorreu um erro crítico ao extrair os ficheiros de dados do Tesseract.", e);
            throw new IOException("Não foi possível inicializar o Tesseract.", e);
        }
    }
}

