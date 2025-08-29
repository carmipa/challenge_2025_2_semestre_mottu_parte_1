package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.patio.PatioRequestDto;
import br.com.fiap.mottu.dto.patio.PatioResponseDto;
import br.com.fiap.mottu.model.Patio;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface PatioMapper {

    Patio toEntity(PatioRequestDto patioRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Patio partialUpdate(PatioRequestDto patioRequestDto, @MappingTarget Patio patio);

    PatioResponseDto toResponseDto(Patio patio);

    // NOVO MÉTODO: Para popular formulários de edição
    PatioRequestDto toRequestDto(Patio patio);
}