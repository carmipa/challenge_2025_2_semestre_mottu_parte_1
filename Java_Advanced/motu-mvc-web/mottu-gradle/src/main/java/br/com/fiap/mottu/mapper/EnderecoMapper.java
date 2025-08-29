package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.endereco.EnderecoRequestDto;
import br.com.fiap.mottu.dto.endereco.EnderecoResponseDto;
import br.com.fiap.mottu.model.Endereco;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface EnderecoMapper {

    Endereco toEntity(EnderecoRequestDto enderecoRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Endereco partialUpdate(EnderecoRequestDto enderecoRequestDto, @MappingTarget Endereco endereco);

    EnderecoResponseDto toResponseDto(Endereco endereco);

    // NOVO MÉTODO: Para popular formulários de edição
    EnderecoRequestDto toRequestDto(Endereco endereco);
}