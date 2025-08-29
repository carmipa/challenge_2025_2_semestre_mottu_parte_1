package br.com.fiap.mottu.repository;

import br.com.fiap.mottu.model.Veiculo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;

@Repository
public interface VeiculoRepository extends JpaRepository<Veiculo, Long>, JpaSpecificationExecutor<Veiculo> {

    Optional<Veiculo> findByPlaca(String placa);
    Optional<Veiculo> findByRenavam(String renavam);
    Optional<Veiculo> findByChassi(String chassi);
    Optional<Veiculo> findByTagBleId(String tagBleId); // NOVO MÉTODO

    List<Veiculo> findByModeloContainingIgnoreCase(String modelo);
    List<Veiculo> findByFabricanteContainingIgnoreCase(String fabricante);
    List<Veiculo> findByAno(Integer ano);
    List<Veiculo> findByAnoBetween(Integer startAno, Integer endAno);
    List<Veiculo> findByCombustivelContainingIgnoreCase(String combustivel);
}
