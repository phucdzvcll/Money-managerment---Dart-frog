import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';

abstract class BaseMapper<RQ extends BaseRequestDto?, E extends BaseEntity,
    RP extends BaseResponseDto> {
  E fromRequestDto(RQ dto);

  RP toResponseDto(E entity);

  List<E> fromRequestDtoList(List<RQ> dtos) {
    return dtos.map((dto) => fromRequestDto(dto)).toList();
  }

  List<RP> toResponseDtoList(List<E> entities) {
    return entities.map((entity) => toResponseDto(entity)).toList();
  }
}
