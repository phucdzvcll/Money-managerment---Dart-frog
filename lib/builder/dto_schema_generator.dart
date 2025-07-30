// openapi_schema_generator.dart
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mm/builder/anotation.dart';
import 'package:source_gen/source_gen.dart';

class DtoSchemaGenerator implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.openapi_schema.json'],
  };

  static final _checker = TypeChecker.fromRuntime(OpenApiSchema);

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;
    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final reader = LibraryReader(library);

    final buffer = <String, dynamic>{};

    for (final classElement in reader.classes) {
      if (_checker.hasAnnotationOf(classElement)) {
        final schema = generateSchemaFromClass(classElement);
        buffer['schema'] = schema;
      }
    }

    if (buffer.isEmpty) return;

    final outputId = buildStep.inputId.changeExtension('.openapi_schema.json');
    final jsonString = const JsonEncoder.withIndent('  ').convert(buffer);

    await buildStep.writeAsString(outputId, jsonString);
  }

  Map<String, dynamic> generateSchemaFromClass(ClassElement classElement) {
    final schema = <String, dynamic>{
      'type': 'object',
      'properties': <String, dynamic>{},
      'required': <String>[],
    };

    final constructor = classElement.unnamedConstructor;
    if (constructor == null) return schema;

    for (final param in constructor.parameters) {
      final data = _getJsonKeyName(param);
      if (!data.$2) {
        final name = data.$1 ?? param.name;
        final type = param.type;

        schema['properties']![name] = _dartTypeToOpenApiSchema(type);

        if (param.isRequiredNamed || param.isRequiredPositional) {
          schema['required']!.add(name);
        }
      }
    }

    return schema;
  }

  (String?, bool) _getJsonKeyName(ParameterElement param) {
    String? stringValue;
    var isIgnore = false;
    for (final meta in param.metadata) {
      final element = meta.element;
      if (element is ConstructorElement &&
          element.enclosingElement3.name == 'JsonKey') {
        final constantValue = meta.computeConstantValue();
        stringValue = constantValue?.getField('name')?.toStringValue();
        break;
      }
    }

    for (final meta in param.metadata) {
      final element = meta.element;
      if (element is ConstructorElement &&
          element.enclosingElement3.name == 'FieldIgnore') {
        isIgnore = true;
      }
    }
    return (stringValue, isIgnore);
  }

  Map<String, dynamic> _dartTypeToOpenApiSchema(DartType type) {
    final typeStr = type.getDisplayString(withNullability: false);

    if (typeStr == 'String') return {'type': 'string'};
    if (typeStr == 'int' || typeStr == 'double' || typeStr == 'num') {
      return {'type': 'number'};
    }
    if (typeStr == 'bool') return {'type': 'boolean'};

    if (type is ParameterizedType &&
        typeStr.startsWith('List<') &&
        type.typeArguments.length == 1) {
      final itemType = type.typeArguments.first;
      return {
        'type': 'array',
        'items': _dartTypeToOpenApiSchema(itemType),
      };
    }

    return {'type': 'object'};
  }
}
