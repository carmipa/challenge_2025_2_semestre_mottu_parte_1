package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.patio.PatioRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.PatioFilter;
import br.com.fiap.mottu.mapper.PatioMapper;
import br.com.fiap.mottu.model.Patio;
import br.com.fiap.mottu.service.PatioService;
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
@RequestMapping("/patios")
public class PatioController {

    private final PatioService patioService;
    private final PatioMapper patioMapper;

    public PatioController(PatioService patioService, PatioMapper patioMapper) {
        this.patioService = patioService;
        this.patioMapper = patioMapper;
    }

    @GetMapping("/listar")
    public String listar(Model model, @ModelAttribute("filter") PatioFilter filter, @PageableDefault(size = 10, sort = "nomePatio") Pageable pageable) {
        Page<Patio> page = patioService.buscarPatiosPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(patioMapper::toResponseDto));
        return "patio/listar";
    }

    @GetMapping("/cadastrar")
    public String exibirFormularioCadastro(Model model) {
        if (!model.containsAttribute("patioDto")) {
            model.addAttribute("patioDto", new PatioRequestDto(null, null, null, null));
        }
        return "patio/cadastrar";
    }

    @PostMapping("/cadastrar")
    public String cadastrar(@Valid @ModelAttribute("patioDto") PatioRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "patio/cadastrar";
        }
        try {
            patioService.criarPatio(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Pátio criado com sucesso!");
            return "redirect:/patios/listar";
        } catch (DuplicatedResourceException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "patio/cadastrar";
        }
    }

    @GetMapping("/alterar/{id}")
    public String exibirFormularioAlteracao(@PathVariable Long id, Model model) {
        Patio patio = patioService.buscarPatioPorId(id);
        model.addAttribute("patioDto", patioMapper.toRequestDto(patio));
        model.addAttribute("patioId", id);
        return "patio/alterar";
    }

    @PostMapping("/alterar/{id}")
    public String alterar(@PathVariable Long id, @Valid @ModelAttribute("patioDto") PatioRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("patioId", id);
            return "patio/alterar";
        }
        try {
            patioService.atualizarPatio(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Pátio atualizado com sucesso!");
            return "redirect:/patios/listar";
        } catch (DuplicatedResourceException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("patioId", id);
            return "patio/alterar";
        }
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        Patio patio = patioService.buscarPatioPorId(id);
        model.addAttribute("patio", patioMapper.toResponseDto(patio));
        return "patio/detalhes";
    }

    @GetMapping("/deletar/{id}")
    public String exibirConfirmacaoDelecao(@PathVariable Long id, Model model) {
        Patio patio = patioService.buscarPatioPorId(id);
        model.addAttribute("patio", patioMapper.toResponseDto(patio));
        return "patio/deletar";
    }

    @PostMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            patioService.deletarPatio(id);
            redirectAttributes.addFlashAttribute("successMessage", "Pátio deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar pátio: " + e.getMessage());
        }
        return "redirect:/patios/listar";
    }
}