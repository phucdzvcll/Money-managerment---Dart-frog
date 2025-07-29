import 'package:build/build.dart';
import 'package:mm/builder/dto_schema_generator.dart';
import 'package:mm/builder/open_api_combine_builder.dart';
import 'package:mm/builder/open_api_generator.dart';

Builder openApiBuilder(BuilderOptions options) => OpenApiBuilder();

Builder openApiCombinerBuilder(BuilderOptions options) =>
    OpenApiCombinerBuilder();

Builder openApiSchemaBuilder(BuilderOptions options) => DtoSchemaGenerator();