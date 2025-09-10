package br.com.fiap.mottu.service.vaga;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.PreparedStatement;
import java.util.*;

@Service
public class VagaOracleService {

    private final JdbcTemplate jdbc;

    public VagaOracleService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Transactional(readOnly = true)
    public List<BoxRow> listarBoxesComPlaca() {
        String sql = """
            SELECT b.ID_BOX, b.NOME, b.STATUS, b.DATA_ENTRADA, b.DATA_SAIDA, b.OBSERVACAO,
                   v.PLACA
              FROM TB_BOX b
              LEFT JOIN TB_VEICULOBOX vb ON vb.TB_BOX_ID_BOX = b.ID_BOX
              LEFT JOIN TB_VEICULO v ON v.ID_VEICULO = vb.TB_VEICULO_ID_VEICULO
              ORDER BY b.ID_BOX
            """;
        return jdbc.query(sql, (rs, i) -> new BoxRow(
                rs.getLong("ID_BOX"),
                rs.getString("NOME"),
                rs.getString("STATUS"),
                rs.getDate("DATA_ENTRADA") == null ? null : rs.getDate("DATA_ENTRADA").toLocalDate(),
                rs.getDate("DATA_SAIDA") == null ? null : rs.getDate("DATA_SAIDA").toLocalDate(),
                rs.getString("OBSERVACAO"),
                rs.getString("PLACA")
        ));
    }

    @Transactional(readOnly = true)
    public Optional<Long> findVeiculoIdByPlaca(String placa) {
        String sql = "SELECT ID_VEICULO FROM TB_VEICULO WHERE UPPER(PLACA) = ?";
        List<Long> ids = jdbc.query(sql, ps -> ps.setString(1, placa.toUpperCase()),
                (rs, i) -> rs.getLong("ID_VEICULO"));
        return ids.isEmpty() ? Optional.empty() : Optional.of(ids.getFirst());
    }

    @Transactional
    public Long createVeiculoComPlaca(String placa) {
        String sql = "INSERT INTO TB_VEICULO (PLACA) VALUES (?)";
        KeyHolder kh = new GeneratedKeyHolder();
        jdbc.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, new String[]{"ID_VEICULO"});
            ps.setString(1, placa.toUpperCase());
            return ps;
        }, kh);
        Number key = kh.getKey();
        if (key == null) {
            throw new IllegalStateException("Não foi possível obter ID do veículo criado.");
        }
        return key.longValue();
    }

    @Transactional(readOnly = true)
    public Optional<Long> firstBoxLivreId() {
        String sql = """
            SELECT b.ID_BOX
              FROM TB_BOX b
              LEFT JOIN TB_VEICULOBOX vb ON vb.TB_BOX_ID_BOX = b.ID_BOX
             WHERE b.STATUS = 'L'
               AND vb.TB_BOX_ID_BOX IS NULL
             ORDER BY b.ID_BOX
            """;
        List<Long> ids = jdbc.query(sql, (rs, i) -> rs.getLong(1));
        return ids.isEmpty() ? Optional.empty() : Optional.of(ids.getFirst());
    }

    @Transactional
    public void ocuparBox(Long boxId) {
        jdbc.update("UPDATE TB_BOX SET STATUS = 'O', DATA_ENTRADA = SYSDATE, DATA_SAIDA = NULL WHERE ID_BOX = ?", boxId);
    }

    @Transactional
    public void vincularVeiculoBox(Long veiculoId, Long boxId) {
        jdbc.update("INSERT INTO TB_VEICULOBOX (TB_VEICULO_ID_VEICULO, TB_BOX_ID_BOX) VALUES (?, ?)", veiculoId, boxId);
    }

    @Transactional
    public void liberarBox(Long boxId) {
        jdbc.update("DELETE FROM TB_VEICULOBOX WHERE TB_BOX_ID_BOX = ?", boxId);
        jdbc.update("UPDATE TB_BOX SET STATUS = 'L', DATA_SAIDA = SYSDATE WHERE ID_BOX = ?", boxId);
    }

    @Transactional
    public AlocacaoResult alocarPlaca(String placa, Long preferidoBoxId) {
        String p = placa == null ? "" : placa.trim().toUpperCase();
        if (p.isEmpty()) throw new IllegalArgumentException("Placa é obrigatória.");

        Long veiculoId = findVeiculoIdByPlaca(p).orElseGet(() -> createVeiculoComPlaca(p));

        // já alocada?
        Optional<BuscaBox> ja = buscarBoxPorPlaca(p);
        if (ja.isPresent()) {
            throw new IllegalStateException("Placa já alocada no box " + ja.get().idBox() + " (" + ja.get().nomeBox() + ")");
        }

        Long boxId = (preferidoBoxId != null) ? preferidoBoxId
                : firstBoxLivreId().orElseThrow(() -> new IllegalStateException("Não há boxes livres."));

        int ocupados = jdbc.queryForObject(
                "SELECT COUNT(1) FROM TB_VEICULOBOX WHERE TB_BOX_ID_BOX = ?",
                Integer.class, boxId
        );
        if (ocupados > 0) throw new IllegalStateException("Box já ocupado: " + boxId);

        ocuparBox(boxId);
        vincularVeiculoBox(veiculoId, boxId);

        return new AlocacaoResult(veiculoId, boxId, p);
    }

    /** NOVO: retorna o box atual da placa, se houver (id e nome do box). */
    @Transactional(readOnly = true)
    public Optional<BuscaBox> buscarBoxPorPlaca(String placa) {
        String sql = """
            SELECT b.ID_BOX, b.NOME, b.STATUS
              FROM TB_VEICULO v
              JOIN TB_VEICULOBOX vb ON vb.TB_VEICULO_ID_VEICULO = v.ID_VEICULO
              JOIN TB_BOX b        ON b.ID_BOX = vb.TB_BOX_ID_BOX
             WHERE UPPER(v.PLACA) = ?
            """;
        List<BuscaBox> list = jdbc.query(sql,
                ps -> ps.setString(1, placa.toUpperCase()),
                (rs, i) -> new BuscaBox(rs.getLong("ID_BOX"), rs.getString("NOME"), rs.getString("STATUS")));
        return list.isEmpty() ? Optional.empty() : Optional.of(list.getFirst());
    }

    // ---------- tipos auxiliares ----------
    public record BoxRow(Long idBox, String nome, String status,
                         java.time.LocalDate dataEntrada, java.time.LocalDate dataSaida,
                         String observacao, String placa) {}

    public record AlocacaoResult(Long veiculoId, Long boxId, String placa) {}

    public record BuscaBox(Long idBox, String nomeBox, String status) {}
}
