package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.box.BoxRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.BoxFilter;
import br.com.fiap.mottu.mapper.BoxMapper;
import br.com.fiap.mottu.model.Box;
import br.com.fiap.mottu.service.BoxService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
@RequestMapping("/boxes")
public class BoxController {

    private static final Logger log = LoggerFactory.getLogger(BoxController.class);
    private final BoxService boxService;
    private final BoxMapper boxMapper;

    @Autowired
    public BoxController(BoxService boxService, BoxMapper boxMapper) {
        this.boxService = boxService;
        this.boxMapper = boxMapper;
    }

    @GetMapping("/listar")
    public String listar(Model model, @ModelAttribute("filter") BoxFilter filter, @PageableDefault(size = 10, sort = "nome") Pageable pageable) {
        Page<Box> page = boxService.buscarBoxesPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(boxMapper::toResponseDto));
        return "box/listar";
    }

    @GetMapping("/cadastrar")
    public String exibirFormularioCadastro(Model model) {
        if (!model.containsAttribute("boxDto")) {
            model.addAttribute("boxDto", new BoxRequestDto(null, "L", null, null, null));
        }
        return "box/cadastrar";
    }

    @PostMapping("/cadastrar")
    public String cadastrar(@Valid @ModelAttribute("boxDto") BoxRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "box/cadastrar";
        }
        try {
            boxService.criarBox(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Box criado com sucesso!");
            return "redirect:/boxes/listar";
        } catch (DuplicatedResourceException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "box/cadastrar";
        }
    }

    @GetMapping("/alterar/{id}")
    public String exibirFormularioAlteracao(@PathVariable Long id, Model model) {
        Box box = boxService.buscarBoxPorId(id);
        model.addAttribute("boxDto", boxMapper.toRequestDto(box));
        model.addAttribute("boxId", id);
        return "box/alterar";
    }

    @PostMapping("/alterar/{id}")
    public String alterar(@PathVariable Long id, @Valid @ModelAttribute("boxDto") BoxRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("boxId", id);
            return "box/alterar";
        }
        try {
            boxService.atualizarBox(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Box atualizado com sucesso!");
            return "redirect:/boxes/listar";
        } catch (DuplicatedResourceException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("boxId", id);
            return "box/alterar";
        }
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        Box box = boxService.buscarBoxPorId(id);
        model.addAttribute("box", boxMapper.toResponseDto(box));
        return "box/detalhes";
    }

    @GetMapping("/deletar/{id}")
    public String exibirConfirmacaoDelecao(@PathVariable Long id, Model model) {
        Box box = boxService.buscarBoxPorId(id);
        model.addAttribute("box", boxMapper.toResponseDto(box));
        return "box/deletar";
    }

    @PostMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            boxService.deletarBox(id);
            redirectAttributes.addFlashAttribute("successMessage", "Box deletado com sucesso!");
        } catch (Exception e) {
            log.error("Erro ao deletar box {}", id, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar box. Verifique dependências.");
        }
        return "redirect:/boxes/listar";
    }
}