import 'package:dart_frog/dart_frog.dart';

Middleware corsMiddleware() {
  return (handler) {
    return (context) async {
      final origin = context.request.headers['origin'] ?? '';

      const allowedOrigins = [
        'http://localhost:8082',
      ];

      // Handle preflight
      if (context.request.method == HttpMethod.options) {
        if (allowedOrigins.contains(origin)) {
          return Response(
            statusCode: 200,
            headers: {
              'Access-Control-Allow-Origin': origin,
              'Access-Control-Allow-Credentials': 'true',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers':
                  'Origin, Content-Type, Accept, Authorization, X-CSRF-Token, X-Client-Platform',
            },
          );
        }
      }

      // Normal request
      final response = await handler(context);
      if (allowedOrigins.contains(origin)) {
        return response.copyWith(
          headers: {
            ...response.headers,
            'Access-Control-Allow-Origin': origin,
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept, Authorization, X-CSRF-Token, X-Client-Platform',
          },
        );
      }
      return response;
    };
  };
}
