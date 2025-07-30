import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

class OpenApiCombinerBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!buildStep.inputId.path.endsWith('openapi.dart')) return;

    final inputAssets =
        await buildStep.findAssets(Glob('**/*.openapi.json')).toList();

    final Map<String, dynamic> map = {
      "openapi": "3.0.0",
      "info": {
        "title": "FunnyDev API",
        "version": "1.0.0",
        "description": "API documentation for FunnyDev Dart Frog backend"
      },
      "servers": [
        {"url": "http://localhost:8081"}
      ],
      "components": {
        "securitySchemes": {
          "BearerAuth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT"
          }
        }
      },
      "security": [
        {"BearerAuth": []}
      ],
      "paths": <String, dynamic>{},
    };
    for (final input in inputAssets) {
      try {
        final decode = jsonDecode(await buildStep.readAsString(input));

        (map['paths']! as Map<String, dynamic>)
            .addAll(decode as Map<String, dynamic>);
      } catch (e) {
        print('====================== $e');
      }
    }

    final string = jsonEncode(map);

    final output = buildStep.inputId.changeExtension('.json');

    await buildStep.writeAsString(output, string);
  }
}
