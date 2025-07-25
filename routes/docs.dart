import 'package:dart_frog/dart_frog.dart';

/// Serves the Swagger UI, configured to use /openapi.yaml as the spec.
Future<Response> onRequest(RequestContext context) async {
  final indexHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Swagger UI</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist/swagger-ui.css">
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist/swagger-ui-bundle.js"></script>
  <script>
    window.onload = function() {
      SwaggerUIBundle({
        url: '/openapi',
        dom_id: '#swagger-ui',
      });
    };
  </script>
</body>
</html>
''';
  return Response(body: indexHtml, headers: {'content-type': 'text/html'});
}
