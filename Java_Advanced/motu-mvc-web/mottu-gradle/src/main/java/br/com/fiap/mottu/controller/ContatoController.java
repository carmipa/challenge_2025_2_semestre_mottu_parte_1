package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.contato.ContatoRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.ContatoFilter;
import br.com.fiap.mottu.mapper.ContatoMapper;
import br.com.fiap.mottu.model.Contato;
import br.com.fiap.mottu.service.ContatoService;
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
@RequestMapping("/contatos")
public class ContatoController {

    private final ContatoService contatoService;
    private final ContatoMapper contatoMapper;

    @Autowired
    public ContatoController(ContatoService contatoService, ContatoMapper contatoMapper) {
        this.contatoService = contatoService;
        this.contatoMapper = contatoMapper;
    }

    @GetMapping
    public String listar(Model model, @ModelAttribute("filter") ContatoFilter filter, @PageableDefault(size = 10, sort = "email") Pageable pageable) {
        Page<Contato> page = contatoService.buscarContatosPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(contatoMapper::toResponseDto));
        return "contato/list";
    }

    @GetMapping("/novo")
    public String exibirFormularioCriacao(Model model) {
        if (!model.containsAttribute("contatoDto")) {
            model.addAttribute("contatoDto", new ContatoRequestDto(null, null, null, null, null, null, null, null, null, null));
        }
        return "contato/form";
    }

    @PostMapping("/novo")
    public String criar(@Valid @ModelAttribute("contatoDto") ContatoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            return "contato/form";
        }
        try {
            contatoService.criarContato(dto);
            redirectAttributes.addFlashAttribute("successMessage", "Contato criado com sucesso!");
            return "redirect:/contatos";
        } catch (DuplicatedResourceException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "contato/form";
        }
    }

    @GetMapping("/{id}/editar")
    public String exibirFormularioEdicao(@PathVariable Long id, Model model) {
        Contato contato = contatoService.buscarContatoPorId(id);
        model.addAttribute("contatoDto", contatoMapper.toRequestDto(contato));
        model.addAttribute("contatoId", id);
        return "contato/form";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable Long id, @Valid @ModelAttribute("contatoDto") ContatoRequestDto dto, BindingResult result, RedirectAttributes redirectAttributes, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("contatoId", id);
            return "contato/form";
        }
        try {
            contatoService.atualizarContato(id, dto);
            redirectAttributes.addFlashAttribute("successMessage", "Contato atualizado com sucesso!");
            return "redirect:/contatos";
        } catch (DuplicatedResourceException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("contatoId", id);
            return "contato/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            contatoService.deletarContato(id);
            redirectAttributes.addFlashAttribute("successMessage", "Contato deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar contato: " + e.getMessage());
        }
        return "redirect:/contatos";
    }
}