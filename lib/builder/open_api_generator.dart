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

    for (final openApi in visitor.founded) {
      if ((openApi.requestSchema ?? '').isNotEmpty) {
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

      mapOutPut.addAll(
        openApi.toOpenApi(
          requestSchema: requestSchema,
          responseSchema: responseSchema,
        ),
      );
    }
    final outputJson = const JsonEncoder.withIndent('').convert(mapOutPut);
    await buildStep.writeAsString(outputId, outputJson);
  }
}

class _MyFunctionVisitor extends RecursiveAstVisitor<void> {
  final List<OpenApi> founded = [];

  @override
  Future<void> visitFunctionDeclaration(FunctionDeclaration node) async {
    final metadata = node.metadata;
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
            } else if (label == 'requestSchema') {
              if (value is String && value.isNotEmpty) {
                data = data.copyWith(requestSchema: value);
              }
            } else if (label == 'responseSchema') {
              print('phuc ======= $label $value');
              if (value is String && value.isNotEmpty) {
                data = data.copyWith(responseSchema: value);
              }
            }
          }
        }
        founded.add(data);
      }
    }
  }

  dynamic _extractLiteralValue(Expression expr) {
    if (expr is StringLiteral) return expr.stringValue;
    if (expr is BooleanLiteral) return expr.value;
    if (expr is IntegerLiteral) return expr.value;
    return expr.toSource(); // fallback nếu không phải literal
  }
}
