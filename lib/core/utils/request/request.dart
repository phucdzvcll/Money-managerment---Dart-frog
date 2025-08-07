import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/controller/base_controller.dart';
import 'package:mm/core/model/api_response.dart';
import 'package:mm/core/model/base_dto.dart';
import 'package:mm/core/model/base_entity.dart';
import 'package:mm/core/model/base_mapper.dart';
import 'package:mm/core/repository/base_repository.dart';
import 'package:mm/core/service/base_service.dart';

Future<Response> requestWithId<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>,
    S extends BaseService<E, RQ, RP, R, M>,
    C extends BaseController<E, RQ, RP, M, R, S>>(
  RequestContext context,
  String id,
) async {
  try {
    final requestId = int.tryParse(id)!;

    final controller = context.read<C>();
    final method = context.request.method;
    switch (method) {
      case HttpMethod.get:
        return controller.executeFindById(id: requestId);
      case HttpMethod.delete:
        return controller.executeDeleteById(id: requestId);
      case HttpMethod.post:
      case HttpMethod.head:
      case HttpMethod.options:
      case HttpMethod.patch:
      case HttpMethod.put:
        return Response(statusCode: 405, body: 'Method Not Allowed');
    }
  } catch (e) {
    return badRequest('Invalid ID format');
  }
}

Future<Response> requestWithOutId<
    E extends BaseEntity,
    RQ extends BaseRequestDto,
    RP extends BaseResponseDto,
    R extends BaseRepository<E>,
    M extends BaseMapper<RQ, E, RP>,
    S extends BaseService<E, RQ, RP, R, M>,
    C extends BaseController<E, RQ, RP, M, R, S>>(
  RequestContext context,
) async {
  final controller = context.read<C>();
  final method = context.request.method;
  switch (method) {
    case HttpMethod.get:
      return controller.executeFindAll();
    case HttpMethod.post:
      final body = await controller.body(context);
      return controller.executeCreate(body);
    case HttpMethod.put:
      final body = await controller.body(context);
      return controller.executeUpdate(body);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: 405, body: 'Method Not Allowed');
  }
}
