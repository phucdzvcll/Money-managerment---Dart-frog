import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:mm/builder/anotation.dart';

class OpenApiBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.openapi.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final content = await buildStep.readAsString(inputId);

    final parseResult = parseString(content: content);
    final visitor = _MyFunctionVisitor();
    parseResult.unit.visitChildren(visitor);

    if (visitor.founded.isEmpty) return;
    final outputId = inputId.changeExtension('.openapi.json');
    final mapOutPut = <String, dynamic>{};
    var requestSchema = <String, dynamic>{};
    var responseSchema = <String, dynamic>{};

    for (final data in visitor.founded) {
      final openApi = data.$1;
      if ((openApi.requestSchema ?? '').isNotEmpty || !openApi.isPath) {
        final inputAssets = await buildStep
            .findAssets(Glob('**/${openApi.requestSchema}'))
            .toList();
        for (final input in inputAssets) {
          try {
            final source = await buildStep.readAsString(input);

            requestSchema =
                ((jsonDecode(source) as Map<String, dynamic>)['schema']
                        as Map<String, dynamic>?) ??
                    {};
          } catch (e) {
            print('Error ++++++++  $e');
          }
        }
      }
      if ((openApi.responseSchema ?? '').isNotEmpty) {
        final inputAssets = await buildStep
            .findAssets(Glob('**/${openApi.responseSchema}'))
            .toList();
        for (final input in inputAssets) {
          try {
            final source = await buildStep.readAsString(input);

            responseSchema =
                ((jsonDecode(source) as Map<String, dynamic>)['schema']
                        as Map<String, dynamic>?) ??
                    {};
          } catch (e) {
            print('Error ++++++++  $e');
          }
        }
      }

      if (openApi.isList) {
        final properties = responseSchema['properties'] ?? <String, dynamic>{};
        final required = responseSchema['required'] ?? <String>[];
        responseSchema = {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': properties,
            'required': required,
          },
        };
      }
      final pathParams = data.$2;

      final method = openApi.toOpenApi(
        requestSchema: requestSchema,
        responseSchema: responseSchema,
        pathParams: pathParams,
      );

      if (mapOutPut.containsKey(openApi.path)) {
        (mapOutPut[openApi.path] as Map<String, dynamic>).addAll(
          method[openApi.path] as Map<String, dynamic>,
        );
      } else {
        mapOutPut.addAll(
          method,
        );
      }
    }
    final outputJson = const JsonEncoder.withIndent('').convert(mapOutPut);
    await buildStep.writeAsString(outputId, outputJson);
  }
}

class _MyFunctionVisitor extends RecursiveAstVisitor<void> {
  final List<(OpenApi, List<Map<String, dynamic>>)> founded = [];

  Map<String, dynamic> generatePathParamere(
      String label, bool isRequired, String type) {
    return {
      "name": "$label",
      "in": "path",
      "required": isRequired,
      "schema": {
        "type": type,
      },
    };
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final NodeList<FormalParameter>? param = node.parameters?.parameters;
    _processNode(node.metadata, param);

    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _processNode(node.metadata, null);
    super.visitFunctionDeclaration(node);
  }

  void _processNode(
      NodeList<Annotation> metadata, NodeList<FormalParameter>? params) {
    for (final annotation in metadata) {
      final name = annotation.name.name;
      if (name == 'OpenApi') {
        final args = annotation.arguments?.arguments ?? [];

        var data = const OpenApi(
          path: '',
          method: '',
          summary: '',
          tag: '',
          requestSchema: '',
          responseSchema: '',
        );
        for (final arg in args) {
          if (arg is NamedExpression) {
            final label = arg.name.label.name;
            final value = _extractLiteralValue(arg.expression);
            if (label == 'path') {
              data = data.copyWith(path: value as String);
            } else if (label == 'method') {
              data = data.copyWith(method: value as String);
            } else if (label == 'summary') {
              data = data.copyWith(summary: value as String);
            } else if (label == 'tag') {
              data = data.copyWith(tag: value as String);
            } else if (label == 'isList') {
              data = data.copyWith(isList: value as bool);
            } else if (label == 'requestSchema') {
              if (value is String && value.isNotEmpty) {
                data = data.copyWith(requestSchema: value);
              }
            } else if (label == 'responseSchema') {
              if (value is String && value.isNotEmpty) {
                data = data.copyWith(responseSchema: value);
              }
            } else if (label == 'isPath') {
              if (value is bool) {
                data = data.copyWith(isPath: value);
              }
            }
          }
        }

        final pathParams = <Map<String, dynamic>>[];
        if (data.isPath && params != null && params.isNotEmpty) {
          for (final param in params) {
            var name = '<unknown>';
            var typeStr = 'dynamic';
            var isRequired = false;

            var actual = param;

            if (param is DefaultFormalParameter) {
              actual = param.parameter;

              isRequired = param.requiredKeyword != null;
            }

            if (actual is SimpleFormalParameter) {
              name = actual.name?.lexeme ?? '<unnamed>';
              typeStr = actual.type?.toSource() ?? 'dynamic';

              isRequired = isRequired ||
                  actual.isRequiredNamed ||
                  actual.isRequiredPositional;
            }

            pathParams.add(generatePathParamere(
                name, isRequired, dartTypeToOpenApiType(typeStr)));
          }
        }

        founded.add((data, pathParams));
      }
    }
  }

  String dartTypeToOpenApiType(String dartType) {
    dartType = dartType.trim();

    // Handle List<T>
    final listMatch = RegExp(r'^List<(.+)>$').firstMatch(dartType);
    if (listMatch != null) {
      final innerType = dartTypeToOpenApiType(listMatch.group(1)!);
      return 'array of $innerType';
    }

    // Handle Map<K, V>
    final mapMatch = RegExp(r'^Map<(.+),\s*(.+)>$').firstMatch(dartType);
    if (mapMatch != null) {
      return 'object';
    }

    // Handle simple types
    switch (dartType) {
      case 'int':
        return 'integer';
      case 'double':
        return 'number';
      case 'num':
        return 'number';
      case 'String':
        return 'string';
      case 'bool':
        return 'boolean';
      case 'DateTime':
        return 'string';
      case 'dynamic':
        return 'any';
      default:
        return 'object';
    }
  }

  dynamic _extractLiteralValue(Expression expr) {
    if (expr is StringLiteral) return expr.stringValue;
    if (expr is BooleanLiteral) return expr.value;
    if (expr is IntegerLiteral) return expr.value;
    return expr.toSource(); // fallback nếu không phải literal
  }
}
