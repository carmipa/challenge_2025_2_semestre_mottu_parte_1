package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.veiculo.VeiculoRequestDto;
import br.com.fiap.mottu.dto.veiculo.VeiculoResponseDto;
import br.com.fiap.mottu.model.Veiculo;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface VeiculoMapper {

    Veiculo toEntity(VeiculoRequestDto veiculoRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Veiculo partialUpdate(VeiculoRequestDto veiculoRequestDto, @MappingTarget Veiculo veiculo);

    VeiculoResponseDto toResponseDto(Veiculo veiculo);

    // NOVO MÉTODO: Para popular formulários de edição
    VeiculoRequestDto toRequestDto(Veiculo veiculo);
}