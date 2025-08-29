package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.zona.ZonaRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.ZonaFilter;
import br.com.fiap.mottu.mapper.ZonaMapper;
import br.com.fiap.mottu.model.Zona;
import br.com.fiap.mottu.service.ZonaService;
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
@RequestMapping("/zonas")
public class ZonaController {

    private final ZonaService zonaService;
    private final ZonaMapper zonaMapper;

    public ZonaController(ZonaService zonaService, ZonaMapper zonaMapper) {
        this.zonaService = zonaService;
        this.zonaMapper = zonaMapper;
    }

    @GetMapping("/listar")
    public String listar(Model model, @ModelAttribute("filter") ZonaFilter filter, @PageableDefault(size = 10, sort = "nome") Pageable pageable) {
        Page<Zona> page = zonaService.buscarZonasPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(zonaMapper::toResponseDto));
        return "zona/listar";
    }

    @GetMapping("/cadastrar")
    public String exibirFormularioCadastro(Model model) {
        if (!model.containsAttribute("zonaDto")) {
            model.addAttribute("zonaDto", new ZonaRequestDto(null, null, null, null));
        }
        return "zona/cadastrar";
    }

    @PostMapping("/cadastrar")
    public String cadastrar(@Valid @ModelAttribute("zonaDto") ZonaRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "zona/cadastrar";
        }
        try {
            zonaService.criarZona(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Zona criada com sucesso!");
            return "redirect:/zonas/listar";
        } catch (DuplicatedResourceException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "zona/cadastrar";
        }
    }

    @GetMapping("/alterar/{id}")
    public String exibirFormularioAlteracao(@PathVariable Long id, Model model) {
        Zona zona = zonaService.buscarZonaPorId(id);
        model.addAttribute("zonaDto", zonaMapper.toRequestDto(zona));
        model.addAttribute("zonaId", id);
        return "zona/alterar";
    }

    @PostMapping("/alterar/{id}")
    public String alterar(@PathVariable Long id, @Valid @ModelAttribute("zonaDto") ZonaRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("zonaId", id);
            return "zona/alterar";
        }
        try {
            zonaService.atualizarZona(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Zona atualizada com sucesso!");
            return "redirect:/zonas/listar";
        } catch (DuplicatedResourceException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("zonaId", id);
            return "zona/alterar";
        }
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        Zona zona = zonaService.buscarZonaPorId(id);
        model.addAttribute("zona", zonaMapper.toResponseDto(zona));
        return "zona/detalhes";
    }

    @GetMapping("/deletar/{id}")
    public String exibirConfirmacaoDelecao(@PathVariable Long id, Model model) {
        Zona zona = zonaService.buscarZonaPorId(id);
        model.addAttribute("zona", zonaMapper.toResponseDto(zona));
        return "zona/deletar";
    }

    @PostMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            zonaService.deletarZona(id);
            redirectAttributes.addFlashAttribute("successMessage", "Zona deletada com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar zona: " + e.getMessage());
        }
        return "redirect:/zonas/listar";
    }
}