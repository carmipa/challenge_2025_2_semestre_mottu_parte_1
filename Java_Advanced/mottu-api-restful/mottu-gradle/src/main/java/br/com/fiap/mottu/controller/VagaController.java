package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.box.BoxResponseDto;
import br.com.fiap.mottu.service.vaga.VagaOracleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * Endpoints para ocupação de boxes.
 * Sem DTOs extras de "mapa": retornos em JSON simples para a UI.
 */
@RestController
@RequestMapping("/api/vagas")
@Tag(name = "Vagas", description = "Mapa 2D e alocação de boxes (Oracle)")
public class VagaController {

    private final VagaOracleService service;

    public VagaController(VagaOracleService service) {
        this.service = service;
    }

    /**
     * Mapa 2D atual.
     * Retorna um JSON no formato:
     * {
     *   "rows": 4,
     *   "cols": 5,
     *   "boxes": [
     *     { "box": <BoxResponseDto>, "placa": "ABC1D23" | null }
     *   ]
     * }
     */
    @Operation(summary = "Mapa 2D (rows, cols, boxes). Cada item contém { box: BoxResponseDto, placa }")
    @GetMapping("/mapa")
    public ResponseEntity<Map<String, Object>> mapa() {
        // Se tiver layout dinâmico no futuro, troque rows/cols para virem do banco.
        final int rows = 4;
        final int cols = 5;

        var rowsDb = service.listarBoxesComPlaca();

        List<Map<String, Object>> boxes = new ArrayList<>(rowsDb.size());
        for (var r : rowsDb) {
            BoxResponseDto dto = new BoxResponseDto(
                    r.idBox(),
                    r.nome(),
                    r.status(),
                    r.dataEntrada(),
                    r.dataSaida(),
                    r.observacao()
            );
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("box", dto);
            item.put("placa", r.placa()); // null se livre
            boxes.add(item);
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("rows", rows);
        body.put("cols", cols);
        body.put("boxes", boxes);

        return ResponseEntity.ok(body);
    }

    /**
     * Armazena (aloca) uma placa em um box.
     * body:
     * { "placa": "ABC1D23", "boxId": 12 (opcional) }
     *
     * resposta: { ok, message, placa, boxId }
     */
    @Operation(summary = "Armazenar placa (aloca box). Se não informar boxId, usa primeiro livre.")
    @PostMapping("/armazenar")
    public ResponseEntity<Map<String, Object>> armazenar(@RequestBody Map<String, String> body) {
        String placa = Objects.toString(body.get("placa"), "").trim().toUpperCase();
        String boxIdStr = body.get("boxId");
        Long preferido = (boxIdStr == null || boxIdStr.isBlank()) ? null : Long.valueOf(boxIdStr);

        var res = service.alocarPlaca(placa, preferido);

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("ok", true);
        out.put("message", "Vaga cadastrada");
        out.put("placa", res.placa());
        out.put("boxId", res.boxId());
        return ResponseEntity.status(201).body(out);
    }

    /**
     * Libera um box (remove vínculo e marca STATUS='L').
     * resposta: { ok, boxId }
     */
    @Operation(summary = "Liberar box (remove vínculo e marca STATUS='L')")
    @PostMapping("/liberar/{boxId}")
    public ResponseEntity<Map<String, Object>> liberar(@PathVariable Long boxId) {
        service.liberarBox(boxId);
        return ResponseEntity.ok(Map.of("ok", true, "boxId", boxId));
    }

    /**
     * Busca a placa e diz em qual box está.
     * resposta, quando encontrado:
     * { found: true, placa, boxId, boxNome, status }
     * caso contrário:
     * { found: false, placa }
     */
    @Operation(summary = "Buscar placa e retornar box atual")
    @GetMapping("/buscar-placa/{placa}")
    public ResponseEntity<Map<String, Object>> buscarPlaca(@PathVariable String placa) {
        return service.buscarBoxPorPlaca(placa)
                .<ResponseEntity<Map<String, Object>>>map(b -> ResponseEntity.ok(Map.of(
                        "found", true,
                        "placa", placa.toUpperCase(),
                        "boxId", b.idBox(),
                        "boxNome", b.nomeBox(),
                        "status", b.status()
                )))
                .orElse(ResponseEntity.ok(Map.of("found", false, "placa", placa.toUpperCase())));
    }
}
