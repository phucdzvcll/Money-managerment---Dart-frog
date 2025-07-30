class OpenApi {
  const OpenApi({
    required this.path,
    required this.method,
    required this.summary,
    required this.tag,
    this.requestSchema,
    this.responseSchema,
    this.isList = false,
    this.isPath = false,
  });

  final String path;
  final String method;
  final String summary;
  final String tag;
  final String? requestSchema;
  final String? responseSchema;
  final bool isList;
  final bool isPath;

  Map<String, dynamic> toOpenApi({
    Map<String, dynamic> requestSchema = const {},
    Map<String, dynamic> responseSchema = const {},
    List<Map<String, dynamic>> pathParams = const [],
  }) {
    final param = MapEntry(
        isPath ? 'parameters' : 'requestBody',
        isPath
            ? pathParams
            : {
                'required': true,
                'content': {
                  'application/json': {
                    'schema': requestSchema,
                  },
                },
              });

    final methodMap = {
      'summary': summary,
      'tags': [tag],
      'responses': {
        '200': {
          'description': 'Successful',
          'content': {
            'application/json': {
              'schema': responseSchema,
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
    };

    if (isPath) {
      methodMap.addEntries([param]);
    } else if (method.toLowerCase() != 'get' &&
        method.toLowerCase() != 'delete') {
      methodMap.addEntries([param]);
    }

    return {
      path: {
        method.toLowerCase(): methodMap,
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
    bool? isList,
    bool? isPath = false,
  }) {
    return OpenApi(
      path: path ?? this.path,
      method: method ?? this.method,
      summary: summary ?? this.summary,
      tag: tag ?? this.tag,
      requestSchema: requestSchema ?? this.requestSchema,
      responseSchema: responseSchema ?? this.responseSchema,
      isList: isList ?? this.isList,
      isPath: isPath ?? this.isPath,
    );
  }
}

class OpenApiSchema {
  const OpenApiSchema();
}
