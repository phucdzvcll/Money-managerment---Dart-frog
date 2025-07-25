import 'package:dart_frog/dart_frog.dart';
import 'package:mm/feature/credit/repository/credit_repository.dart';
import 'package:mm/feature/credit/service/credit_service.dart';
import 'package:postgres/postgres.dart';

Middleware _creditRepositoryMiddleware(Handler handler) {
  return provider<Future<CreditRepository>>((context) async {
    final connection = await context.read<Future<Connection>>();
    return CreditRepositoryImpl(connection, 'credits');
  });
}

Middleware _creditServiceMiddleware(Handler handler) {
  return provider<Future<CreditService>>((context) async {
    final repository = await context.read<Future<CreditRepository>>();
    return CreditServiceImpl(repository);
  });
}

Handler middleware(Handler handler) {
  return handler
      .use(_creditRepositoryMiddleware(handler))
      .use(_creditServiceMiddleware(handler));
}
