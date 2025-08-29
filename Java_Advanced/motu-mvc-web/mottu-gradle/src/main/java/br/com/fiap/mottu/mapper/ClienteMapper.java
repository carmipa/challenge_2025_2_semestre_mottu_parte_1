package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.cliente.ClienteRequestDto;
import br.com.fiap.mottu.dto.cliente.ClienteResponseDto;
import br.com.fiap.mottu.model.Cliente;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring",
        uses = { EnderecoMapper.class, ContatoMapper.class }
)
public interface ClienteMapper {

    @Mapping(target = "endereco", source = "enderecoRequestDto")
    @Mapping(target = "contato", source = "contatoRequestDto")
    Cliente toEntity(ClienteRequestDto clienteRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "endereco", source = "enderecoRequestDto")
    @Mapping(target = "contato", source = "contatoRequestDto")
    Cliente partialUpdate(ClienteRequestDto clienteRequestDto, @MappingTarget Cliente cliente);

    @Mapping(target = "enderecoResponseDto", source = "endereco")
    @Mapping(target = "contatoResponseDto", source = "contato")
    ClienteResponseDto toResponseDto(Cliente cliente);

    // NOVO MÉTODO: Para popular formulários de edição
    @Mapping(source = "endereco", target = "enderecoRequestDto")
    @Mapping(source = "contato", target = "contatoRequestDto")
    ClienteRequestDto toRequestDto(Cliente cliente);
}