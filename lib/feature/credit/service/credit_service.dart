import 'package:injectable/injectable.dart';
import 'package:mm/core/service/base_service.dart';
import 'package:mm/feature/credit/entities/credit_entity.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';

abstract base class CreditService
    extends BaseService<CreditEntity, CreditRepository> {
  CreditService(super.repository);
}

@Injectable(as: CreditService)
base class CreditServiceImpl extends CreditService {
  CreditServiceImpl(super.repository);
}
