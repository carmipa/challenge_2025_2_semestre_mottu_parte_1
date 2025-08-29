package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.contato.ContatoRequestDto;
import br.com.fiap.mottu.dto.contato.ContatoResponseDto;
import br.com.fiap.mottu.model.Contato;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface ContatoMapper {

    Contato toEntity(ContatoRequestDto contatoRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Contato partialUpdate(ContatoRequestDto contatoRequestDto, @MappingTarget Contato contato);

    ContatoResponseDto toResponseDto(Contato contato);

    // NOVO MÉTODO: Para popular formulários de edição
    ContatoRequestDto toRequestDto(Contato contato);
}