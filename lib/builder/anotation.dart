class OpenApi {
  const OpenApi({
    required this.path,
    required this.method,
    required this.summary,
    required this.tag,
    this.requestSchema,
    this.responseSchema,
  });

  final String path;
  final String method;
  final String summary;
  final String tag;
  final String? requestSchema;
  final String? responseSchema;

  Map<String, dynamic> toOpenApi({
    Map<String, dynamic> requestSchema = const {},
    Map<String, dynamic> responseSchema = const {},
  }) {
    return {
      path: {
        method.toLowerCase(): {
          'summary': summary,
          'tags': [tag],
          'requestBody': {
            'required': true,
            'content': {
              'application/json': {
                'schema': requestSchema,
              },
            },
          },
          'responses': {
            '200': {
              'description': 'Successful',
              'content': {
                'application/json': {
                  'schema': responseSchema.isNotEmpty
                      ? responseSchema
                      : {'type': 'object', 'properties': <dynamic, dynamic>{}},
                },
              },
            },
            '400': {
              'description': 'Bad Request',
              'content': {
                'application/json': {
                  'schema': {
                    'type': 'object',
                    'properties': {
                      'code': {'type': 'integer', 'example': 400},
                      'success': {'type': 'boolean', 'example': false},
                      'error': {
                        'type': 'object',
                        'properties': {
                          'code': {'type': 'string', 'example': '40_2025_1'},
                          'message': {
                            'type': 'string',
                            'nullable': true,
                            'example': null,
                          },
                        },
                        'required': ['code', 'message'],
                      },
                    },
                    'required': ['code', 'success', 'error'],
                  },
                },
              },
            },
          },
        },
      },
    };
  }

  OpenApi copyWith({
    String? path,
    String? method,
    String? summary,
    String? tag,
    String? responseSchema,
    String? requestSchema,
  }) {
    return OpenApi(
      path: path ?? this.path,
      method: method ?? this.method,
      summary: summary ?? this.summary,
      tag: tag ?? this.tag,
      requestSchema: requestSchema ?? this.requestSchema,
      responseSchema: responseSchema ?? this.responseSchema,
    );
  }
}

class OpenApiSchema {
  const OpenApiSchema();
}
