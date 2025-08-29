package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.rastreamento.RastreamentoRequestDto;
import br.com.fiap.mottu.dto.rastreamento.RastreamentoResponseDto;
import br.com.fiap.mottu.model.Rastreamento;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface RastreamentoMapper {

    Rastreamento toEntity(RastreamentoRequestDto rastreamentoRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Rastreamento partialUpdate(RastreamentoRequestDto dto, @MappingTarget Rastreamento rastreamento);

    RastreamentoResponseDto toResponseDto(Rastreamento rastreamento);

    // NOVO MÉTODO: Para popular formulários de edição
    RastreamentoRequestDto toRequestDto(Rastreamento rastreamento);
}