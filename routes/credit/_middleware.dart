import 'package:dart_frog/dart_frog.dart';
import 'package:mm/core/utils/middleware.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';
import 'package:mm/feature/credit/service/credit_service.dart';

Middleware _creditRepositoryMiddleware(Handler handler) =>
    connectionUserMiddleware(handler, (connection, user, context) {
      return CreditRepositoryImpl(connection, 'credits', user);
    });

Middleware _creditServiceMiddleware(Handler handler) {
  return provider<CreditService>((context) {
    final repository = context.read<CreditRepository>();
    return CreditServiceImpl(repository);
  });
}

Handler middleware(Handler handler) {
  return handler
      .use(_creditRepositoryMiddleware(handler))
      .use(_creditServiceMiddleware(handler));
}
