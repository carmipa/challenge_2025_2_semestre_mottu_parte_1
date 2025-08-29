package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.endereco.EnderecoRequestDto;
import br.com.fiap.mottu.exception.InvalidInputException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.EnderecoFilter;
import br.com.fiap.mottu.mapper.EnderecoMapper;
import br.com.fiap.mottu.model.Endereco;
import br.com.fiap.mottu.service.EnderecoService;
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
@RequestMapping("/enderecos")
public class EnderecoController {

    private final EnderecoService enderecoService;
    private final EnderecoMapper enderecoMapper;

    @Autowired
    public EnderecoController(EnderecoService enderecoService, EnderecoMapper enderecoMapper) {
        this.enderecoService = enderecoService;
        this.enderecoMapper = enderecoMapper;
    }

    @GetMapping
    public String listar(Model model, @ModelAttribute("filter") EnderecoFilter filter, @PageableDefault(size = 10, sort = "cep") Pageable pageable) {
        Page<Endereco> page = enderecoService.buscarEnderecosPorFiltro(filter, pageable);
        model.addAttribute("page", page.map(enderecoMapper::toResponseDto));
        return "endereco/list";
    }

    @GetMapping("/novo")
    public String exibirFormularioCriacao(Model model) {
        if (!model.containsAttribute("enderecoDto")) {
            model.addAttribute("enderecoDto", new EnderecoRequestDto(null, null, null, null, null));
        }
        return "endereco/form";
    }

    @PostMapping("/novo")
    public String criar(@Valid @ModelAttribute("enderecoDto") EnderecoRequestDto dto, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "endereco/form";
        }
        try {
            enderecoService.criarEndereco(dto).block();
            redirectAttributes.addFlashAttribute("successMessage", "Endereço criado com sucesso!");
            return "redirect:/enderecos";
        } catch (InvalidInputException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "endereco/form";
        }
    }

    @GetMapping("/{id}/editar")
    public String exibirFormularioEdicao(@PathVariable Long id, Model model) {
        Endereco endereco = enderecoService.buscarEnderecoPorId(id);
        model.addAttribute("enderecoDto", enderecoMapper.toRequestDto(endereco));
        model.addAttribute("enderecoId", id);
        return "endereco/form";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable Long id, @Valid @ModelAttribute("enderecoDto") EnderecoRequestDto dto, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("enderecoId", id);
            return "endereco/form";
        }
        try {
            enderecoService.atualizarEndereco(id, dto).block();
            redirectAttributes.addFlashAttribute("successMessage", "Endereço atualizado com sucesso!");
            return "redirect:/enderecos";
        } catch (InvalidInputException | ResourceNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("enderecoId", id);
            return "endereco/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            enderecoService.deletarEndereco(id);
            redirectAttributes.addFlashAttribute("successMessage", "Endereço deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erro ao deletar endereço: " + e.getMessage());
        }
        return "redirect:/enderecos";
    }
}