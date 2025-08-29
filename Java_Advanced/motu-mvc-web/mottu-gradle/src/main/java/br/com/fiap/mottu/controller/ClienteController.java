package br.com.fiap.mottu.controller;

import br.com.fiap.mottu.dto.cliente.ClienteRequestDto;
import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.InvalidInputException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import br.com.fiap.mottu.filter.ClienteFilter;
import br.com.fiap.mottu.mapper.ClienteMapper;
import br.com.fiap.mottu.model.Cliente;
import br.com.fiap.mottu.service.ClienteService;
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
@RequestMapping("/clientes")
public class ClienteController {

    private static final Logger log = LoggerFactory.getLogger(ClienteController.class);
    private final ClienteService clienteService;
    private final ClienteMapper clienteMapper;

    @Autowired
    public ClienteController(ClienteService clienteService, ClienteMapper clienteMapper) {
        this.clienteService = clienteService;
        this.clienteMapper = clienteMapper;
    }

    @GetMapping
    public String listar(Model model, @ModelAttribute("filter") ClienteFilter filter, @PageableDefault(size = 10, sort = "nome") Pageable pageable) {
        log.info("Buscando clientes com filtro: {} e paginação: {}", filter, pageable);
        Page<Cliente> clientesPage = clienteService.buscarClientesPorFiltro(filter, pageable);
        model.addAttribute("page", clientesPage.map(clienteMapper::toResponseDto));
        model.addAttribute("pageTitle", "cliente.list.title");
        return "cliente/list";
    }

    @GetMapping("/novo")
    public String exibirFormularioCriacao(Model model) {
        if (!model.containsAttribute("clienteDto")) {
            model.addAttribute("clienteDto", new ClienteRequestDto(null, null, null, null, null, null, null, null, null));
        }
        model.addAttribute("pageTitle", "cliente.form.title.new");
        return "cliente/form";
    }

    @PostMapping("/novo")
    public String criar(@Valid @ModelAttribute("clienteDto") ClienteRequestDto clienteDto, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "cliente.form.title.new");
            return "cliente/form";
        }
        try {
            clienteService.criarCliente(clienteDto).block();
            redirectAttributes.addFlashAttribute("successMessage", "Cliente criado com sucesso!");
            return "redirect:/clientes";
        } catch (DuplicatedResourceException | InvalidInputException e) {
            log.error("Erro de negócio ao criar cliente: {}", e.getMessage());
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("pageTitle", "cliente.form.title.new");
            return "cliente/form";
        } catch (Exception e) {
            log.error("Erro inesperado ao criar cliente", e);
            model.addAttribute("errorMessage", "Ocorreu um erro inesperado. Tente novamente.");
            model.addAttribute("pageTitle", "cliente.form.title.new");
            return "cliente/form";
        }
    }

    @GetMapping("/{id}/editar")
    public String exibirFormularioEdicao(@PathVariable Long id, Model model) {
        Cliente cliente = clienteService.buscarClientePorId(id);
        ClienteRequestDto dto = clienteMapper.toRequestDto(cliente);
        model.addAttribute("clienteDto", dto);
        model.addAttribute("clienteId", id);
        model.addAttribute("pageTitle", "cliente.form.title.edit");
        return "cliente/form";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable Long id, @Valid @ModelAttribute("clienteDto") ClienteRequestDto clienteDto, BindingResult bindingResult, RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "cliente.form.title.edit");
            model.addAttribute("clienteId", id);
            return "cliente/form";
        }
        try {
            clienteService.atualizarCliente(id, clienteDto).block();
            redirectAttributes.addFlashAttribute("successMessage", "Cliente atualizado com sucesso!");
            return "redirect:/clientes";
        } catch (ResourceNotFoundException | DuplicatedResourceException | InvalidInputException e) {
            log.error("Erro de negócio ao atualizar cliente {}: {}", id, e.getMessage());
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("pageTitle", "cliente.form.title.edit");
            model.addAttribute("clienteId", id);
            return "cliente/form";
        } catch (Exception e) {
            log.error("Erro inesperado ao atualizar cliente {}", id, e);
            model.addAttribute("errorMessage", "Ocorreu um erro inesperado. Tente novamente.");
            model.addAttribute("pageTitle", "cliente.form.title.edit");
            model.addAttribute("clienteId", id);
            return "cliente/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            clienteService.deletarCliente(id);
            redirectAttributes.addFlashAttribute("successMessage", "Cliente deletado com sucesso!");
        } catch (Exception e) {
            log.error("Erro ao deletar cliente {}", id, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Não foi possível deletar o cliente. Verifique se ele não possui vínculos.");
        }
        return "redirect:/clientes";
    }
}