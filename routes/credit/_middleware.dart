import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware/middleware.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';
import 'package:mm/feature/credit/service/credit_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    featureMiddleware<CreditEntity, CreditRepository, CreditService>(
      CreditServiceImpl.new,
      CreditRepositoryImpl.new,
    ),
  );
}
