package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.rastreamento.RastreamentoRequestDto;
import br.com.fiap.mottu.exception.InvalidInputException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.RastreamentoFilter;
import br.com.fiap.mottu.mapper.RastreamentoMapper;
import br.com.fiap.mottu.model.Rastreamento;
import br.com.fiap.mottu.service.RastreamentoService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/rastreamentos")
public class RastreamentoController {

    private final RastreamentoService rastreamentoService;
    private final RastreamentoMapper rastreamentoMapper;

    public RastreamentoController(RastreamentoService rastreamentoService, RastreamentoMapper rastreamentoMapper) {
        this.rastreamentoService = rastreamentoService;
        this.rastreamentoMapper = rastreamentoMapper;
    }

    @GetMapping
    public String listar(Model model, @ModelAttribute("filter") RastreamentoFilter filter, @PageableDefault(size = 10, sort = "dataHoraRegistro") Pageable pageable) {
        Page<Rastreamento> page = rastreamentoService.buscarRastreamentosPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(rastreamentoMapper::toResponseDto));
        return "rastreamento/list";
    }

    @GetMapping("/novo")
    public String exibirFormularioCriacao(Model model) {
        if (!model.containsAttribute("rastreamentoDto")) {
            model.addAttribute("rastreamentoDto", new RastreamentoRequestDto(null, null, null, null, null, null));
        }
        return "rastreamento/form";
    }

    @PostMapping("/novo")
    public String criar(@Valid @ModelAttribute("rastreamentoDto") RastreamentoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "rastreamento/form";
        }
        try {
            rastreamentoService.criarRastreamento(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Rastreamento criado com sucesso!");
            return "redirect:/rastreamentos";
        } catch (InvalidInputException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "rastreamento/form";
        }
    }

    @GetMapping("/{id}/editar")
    public String exibirFormularioEdicao(@PathVariable Long id, Model model) {
        Rastreamento rastreamento = rastreamentoService.buscarRastreamentoPorId(id);
        model.addAttribute("rastreamentoDto", rastreamentoMapper.toRequestDto(rastreamento));
        model.addAttribute("rastreamentoId", id);
        return "rastreamento/form";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable Long id, @Valid @ModelAttribute("rastreamentoDto") RastreamentoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("rastreamentoId", id);
            return "rastreamento/form";
        }
        try {
            rastreamentoService.atualizarRastreamento(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Rastreamento atualizado com sucesso!");
            return "redirect:/rastreamentos";
        } catch (InvalidInputException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("rastreamentoId", id);
            return "rastreamento/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            rastreamentoService.deletarRastreamento(id);
            redirectAttributes.addFlashAttribute("successMessage", "Rastreamento deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar rastreamento: " + e.getMessage());
        }
        return "redirect:/rastreamentos";
    }
}