package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.zona.ZonaRequestDto;
import br.com.fiap.mottu.dto.zona.ZonaResponseDto;
import br.com.fiap.mottu.model.Zona;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface ZonaMapper {

    Zona toEntity(ZonaRequestDto zonaRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Zona partialUpdate(ZonaRequestDto zonaRequestDto, @MappingTarget Zona zona);

    ZonaResponseDto toResponseDto(Zona zona);

    // NOVO MÉTODO: Para popular formulários de edição
    ZonaRequestDto toRequestDto(Zona zona);
}