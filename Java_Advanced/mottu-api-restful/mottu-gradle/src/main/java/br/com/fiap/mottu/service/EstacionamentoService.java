// src/main/java/br/com/fiap/mottu/service/EstacionamentoService.java
package br.com.fiap.mottu.service;

import br.com.fiap.mottu.exception.InvalidInputException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.model.Box;
import br.com.fiap.mottu.model.Veiculo;
import br.com.fiap.mottu.model.relacionamento.VeiculoBox;
import br.com.fiap.mottu.model.relacionamento.VeiculoBoxId;
import br.com.fiap.mottu.repository.BoxRepository;
import br.com.fiap.mottu.repository.VeiculoRepository;
import br.com.fiap.mottu.repository.relacionamento.VeiculoBoxRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class EstacionamentoService {

    private final VeiculoRepository veiculoRepository;
    private final BoxRepository boxRepository;
    private final VeiculoBoxRepository veiculoBoxRepository;

    @Autowired
    public EstacionamentoService(VeiculoRepository veiculoRepository, BoxRepository boxRepository, VeiculoBoxRepository veiculoBoxRepository) {
        this.veiculoRepository = veiculoRepository;
        this.boxRepository = boxRepository;
        this.veiculoBoxRepository = veiculoBoxRepository;
    }

    @Transactional
    public Box parkMoto(String placa) {
        Veiculo veiculo = veiculoRepository.findByPlaca(placa)
                .orElseThrow(() -> new ResourceNotFoundException("Veículo com placa " + placa + " não cadastrado."));

        // Verifica se o veículo já não está estacionado
        if (veiculo.getVeiculoBoxes() != null && !veiculo.getVeiculoBoxes().isEmpty()) {
            throw new InvalidInputException("Veículo de placa " + placa + " já está estacionado.");
        }

        Box vagaLivre = boxRepository.findAll().stream()
                .filter(box -> "L".equals(box.getStatus()))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Nenhuma vaga livre encontrada."));

        vagaLivre.setStatus("O");
        boxRepository.save(vagaLivre);

        VeiculoBox associacao = new VeiculoBox(veiculo, vagaLivre);
        veiculoBoxRepository.save(associacao);

        return vagaLivre;
    }

    @Transactional
    public void releaseSpot(String placa) {
        Veiculo veiculo = veiculoRepository.findByPlaca(placa)
                .orElseThrow(() -> new ResourceNotFoundException("Veículo com placa " + placa + " não encontrado."));

        VeiculoBox associacao = veiculo.getVeiculoBoxes().stream()
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Veículo com placa " + placa + " não está estacionado em nenhum box."));

        Box boxOcupado = associacao.getBox();
        boxOcupado.setStatus("L");
        boxRepository.save(boxOcupado);

        veiculoBoxRepository.deleteById(associacao.getId());
    }
}