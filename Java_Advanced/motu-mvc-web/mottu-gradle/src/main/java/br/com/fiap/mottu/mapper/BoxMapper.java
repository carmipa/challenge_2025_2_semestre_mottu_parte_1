package br.com.fiap.mottu.mapper;

import br.com.fiap.mottu.dto.box.BoxRequestDto;
import br.com.fiap.mottu.dto.box.BoxResponseDto;
import br.com.fiap.mottu.model.Box;
import org.mapstruct.*;

@Mapper(
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        componentModel = "spring"
)
public interface BoxMapper {

    Box toEntity(BoxRequestDto boxRequestDto);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Box partialUpdate(BoxRequestDto boxRequestDto, @MappingTarget Box box);

    BoxResponseDto toResponseDto(Box box);

    // NOVO MÉTODO: Para popular formulários de edição
    BoxRequestDto toRequestDto(Box box);
}