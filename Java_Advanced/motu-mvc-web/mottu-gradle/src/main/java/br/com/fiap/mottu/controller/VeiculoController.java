package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.veiculo.VeiculoRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.VeiculoFilter;
import br.com.fiap.mottu.mapper.VeiculoMapper;
import br.com.fiap.mottu.model.Veiculo;
import br.com.fiap.mottu.service.VeiculoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/veiculos")
public class VeiculoController {

    private final VeiculoService veiculoService;
    private final VeiculoMapper veiculoMapper;

    @Autowired
    public VeiculoController(VeiculoService veiculoService, VeiculoMapper veiculoMapper) {
        this.veiculoService = veiculoService;
        this.veiculoMapper = veiculoMapper;
    }

    @GetMapping
    public String listar(Model model, @ModelAttribute("filter") VeiculoFilter filter, @PageableDefault(size = 10, sort = "placa") Pageable pageable) {
        Page<Veiculo> page = veiculoService.buscarVeiculosPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(veiculoMapper::toResponseDto));
        return "veiculo/list";
    }

    @GetMapping("/novo")
    public String exibirFormularioCriacao(Model model) {
        if (!model.containsAttribute("veiculoDto")) {
            model.addAttribute("veiculoDto", new VeiculoRequestDto(null, null, null, null, null, null, null, null));
        }
        return "veiculo/form";
    }

    @PostMapping("/novo")
    public String criar(@Valid @ModelAttribute("veiculoDto") VeiculoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "veiculo/form";
        }
        try {
            veiculoService.criarVeiculo(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Veículo criado com sucesso!");
            return "redirect:/veiculos";
        } catch (DuplicatedResourceException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "veiculo/form";
        }
    }

    @GetMapping("/{id}/editar")
    public String exibirFormularioEdicao(@PathVariable Long id, Model model) {
        Veiculo veiculo = veiculoService.buscarVeiculoPorId(id);
        // **ATENÇÃO**: Crie este método `toRequestDto` no seu VeiculoMapper
        model.addAttribute("veiculoDto", veiculoMapper.toRequestDto(veiculo));
        model.addAttribute("veiculoId", id);
        return "veiculo/form";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable Long id, @Valid @ModelAttribute("veiculoDto") VeiculoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("veiculoId", id);
            return "veiculo/form";
        }
        try {
            veiculoService.atualizarVeiculo(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Veículo atualizado com sucesso!");
            return "redirect:/veiculos";
        } catch (DuplicatedResourceException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("veiculoId", id);
            return "veiculo/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            veiculoService.deletarVeiculo(id);
            redirectAttributes.addFlashAttribute("successMessage", "Veículo deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar veículo: " + e.getMessage());
        }
        return "redirect:/veiculos";
    }

    @GetMapping("/{id}/localizacao")
    public String getLocalizacaoVeiculo(@PathVariable Long id, Model model) {
        try {
            model.addAttribute("localizacao", veiculoService.getLocalizacaoVeiculo(id));
            return "veiculo/localizacao"; // -> /templates/veiculo/localizacao.html
        } catch (ResourceNotFoundException e) {
            // Em uma app real, poderíamos redirecionar com uma mensagem de erro
            return "redirect:/veiculos";
        }
    }
}