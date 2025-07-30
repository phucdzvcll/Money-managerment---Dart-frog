import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/auth/entities/user_entity.dart';

abstract class BaseController<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    M extends BaseMapper<RQ, E, RP>,
    R extends BaseRepository<E>,
    S extends BaseService<E, RQ, RP, R, M>> {
  const BaseController(this.service, this.userEntity);

  final S service;

  final UserEntity userEntity;

  Future<RQ> body(RequestContext context);



  Future<Response> create(
    RQ dto,
  ) async {
    final result = await service.create(dto);
    return result.fold(
      ifLeft: (ApiError error) {
        return error.toResponse;
      },
      ifRight: (dto) {
        return SuccessResponse(data: dto).toResponse();
      },
    );
  }

  Future<Response> findAll() async {
    final result = await service.excuteGetAll();
    return result.fold(
      ifLeft: (ApiError error) {
        return error.toResponse;
      },
      ifRight: (dto) {
        return SuccessListResponse(data: dto).toResponse();
      },
    );
  }

  Future<Response> findById(int id) async {
    final result = await service.excuteGetById(id);
    return result.fold(
      ifLeft: (ApiError error) {
        return error.toResponse;
      },
      ifRight: (dto) {
        return SuccessResponse(data: dto).toResponse();
      },
    );
  }

  Future<Response> update(RQ dto) async {
    final result = await service.update(dto);
    return result.fold(
      ifLeft: (ApiError error) {
        return error.toResponse;
      },
      ifRight: (dto) {
        return SuccessResponse(data: dto).toResponse();
      },
    );
  }

  Future<Response> delete(int id) async {
    final result = await service.deleteById(id);
    return result.fold(
      ifLeft: (ApiError error) {
        return error.toResponse;
      },
      ifRight: (_) {
        return successRsponse;
      },
    );
  }

  Future<Response> executeCreate(RQ dto);

  Future<Response> executeFindAll();

  Future<Response> executeFindById({required int id});

  Future<Response> executeDeleteById({required int id});

  Future<Response> executeUpdate(RQ dto);
}
