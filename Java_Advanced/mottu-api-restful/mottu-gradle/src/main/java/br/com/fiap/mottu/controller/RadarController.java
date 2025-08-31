// mottu-gradle/src/main/java/br/com/fiap/mottu/controller/RadarController.java

package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.service.ocr.OcrSession;
import br.com.fiap.mottu.service.ocr.OcrSessionManager;
import br.com.fiap.mottu.service.ocr.TesseractService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/radar")
@Tag(name = "Radar", description = "Operações de OCR com Celular")
public class RadarController {

    private static final Logger log = LoggerFactory.getLogger(RadarController.class);
    private final OcrSessionManager sessionManager;
    private final TesseractService tesseractService;

    public RadarController(OcrSessionManager sessionManager, TesseractService tesseractService) {
        this.sessionManager = sessionManager;
        this.tesseractService = tesseractService;
    }

    @Operation(summary = "Iniciar Sessão de OCR", description = "Cria uma nova sessão para upload de imagem via QR Code.")
    @PostMapping("/iniciar-sessao")
    public ResponseEntity<Map<String, String>> iniciarSessao() {
        OcrSession session = sessionManager.createSession();
        log.info("Nova sessão de OCR criada com ID: {}", session.getId());
        return ResponseEntity.ok(Map.of("sessionId", session.getId()));
    }

    @Operation(summary = "Verificar Status da Sessão", description = "Verifica o status de uma sessão de OCR para polling.")
    @GetMapping("/status-sessao/{sessionId}")
    public ResponseEntity<OcrSession> getStatusSessao(@PathVariable String sessionId) {
        return sessionManager.getSession(sessionId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Upload de Imagem da Placa", description = "Recebe a imagem do celular e a processa.")
    @PostMapping("/upload-imagem/{sessionId}")
    public ResponseEntity<Map<String, String>> uploadImagem(
            @PathVariable String sessionId,
            @RequestParam("image") MultipartFile file) {

        log.info("Recebido upload de imagem para a sessão ID: {}", sessionId);
        OcrSession session = sessionManager.getSession(sessionId)
                .orElse(null);

        if (session == null) {
            return ResponseEntity.status(404).body(Map.of("error", "Sessão inválida ou expirada."));
        }

        try {
            sessionManager.setSessionProcessing(sessionId);
            String recognizedPlate = tesseractService.recognizePlate(file);

            if (recognizedPlate.length() < 7) {
                throw new Exception("Não foi possível reconhecer uma placa válida. Resultado: " + recognizedPlate);
            }

            sessionManager.updateSessionSuccess(sessionId, recognizedPlate);
            log.info("Placa '{}' reconhecida com sucesso para a sessão {}", recognizedPlate, sessionId);
            return ResponseEntity.ok(Map.of("message", "Imagem processada com sucesso!", "plate", recognizedPlate));

        } catch (Exception e) {
            log.error("Erro ao processar imagem para a sessão {}: {}", sessionId, e.getMessage());
            sessionManager.updateSessionError(sessionId, e.getMessage());
            return ResponseEntity.status(500).body(Map.of("error", "Falha ao processar a imagem: " + e.getMessage()));
        }
    }
}