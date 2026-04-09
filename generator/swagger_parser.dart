// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// A robust Swagger-to-Feature generator for Clean Architecture.
/// Supports inline schemas, allOf merging, entities, mappers, and camelCase.
/// UPDATED: Sanitizes illegal characters ({, }) in filenames and identifiers.
void main(List<String> args) async {
  if (args.length < 2) {
    print(
      '❌ Usage: dart generator/swagger_parser.dart <FeatureTag> <PathToSwaggerJson>',
    );
    return;
  }

  final String targetTag = args[0];
  final String jsonPath = args[1];
  final String featureName = _toSnakeCase(targetTag);

  print('🚀 Starting Robust Swagger Parser for Feature: $targetTag...');

  final file = File(jsonPath);
  if (!file.existsSync()) {
    print('❌ Error: $jsonPath not found.');
    return;
  }

  final jsonStr = await file.readAsString();
  final Map<String, dynamic> data = json.decode(jsonStr);

  final baseDir = 'lib/features/$featureName';
  _createDirectories(baseDir);

  final schemas =
      (data['components']?['schemas'] as Map<String, dynamic>?) ?? {};
  final paths = (data['paths'] as Map<String, dynamic>?) ?? {};

  // 1. Discover Paths and Inline Schemas
  final List<GeneratedEndpoint> endpoints = [];
  final Map<String, Map<String, dynamic>> syntheticSchemas = {};

  paths.forEach((path, methods) {
    (methods as Map<String, dynamic>).forEach((method, details) {
      // TAG FALLBACK + SANITIZATION
      final rawPathSegments = path
          .split('/')
          .where((s) => s.isNotEmpty)
          .toList();
      final cleanPathSegments = rawPathSegments.map(_cleanPathSegment).toList();

      final fallbackTag = cleanPathSegments.isNotEmpty
          ? cleanPathSegments[0]
          : 'default';
      final tags =
          (details['tags'] as List<dynamic>?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
          [fallbackTag.toLowerCase()];

      if (tags.contains(targetTag.toLowerCase())) {
        // OPERATION ID FALLBACK + SANITIZATION
        var operationId = details['operationId'] as String?;
        if (operationId == null) {
          final camelPath = cleanPathSegments.map(_capitalize).join('');
          operationId = '${method.toLowerCase()}$camelPath';
        }

        final cleanOperationId = _sanitizeKey(operationId);
        final parts = cleanOperationId.split('_');
        final cleanName = parts.length > 1 ? parts[1] : cleanOperationId;

        final responseRawName = _handleResponseSchemaRaw(
          details,
          cleanName,
          syntheticSchemas,
        );

        endpoints.add(
          GeneratedEndpoint(
            path: path,
            method: method,
            methodName: cleanName,
            returnTypeRaw: responseRawName,
            details: details,
          ),
        );
      }
    });
  });

  if (endpoints.isEmpty) {
    print('⚠️ Warning: No endpoints found for tag "$targetTag".');
    return;
  }

  // 2. Discover Schema Dependencies (using original names)
  final Set<String> modelsToGenerateOriginal = {};
  for (final endpoint in endpoints) {
    if (endpoint.returnTypeRaw != 'dynamic') {
      modelsToGenerateOriginal.add(endpoint.returnTypeRaw);
    }
    final reqRef = _getSchemaRef(endpoint.details['requestBody'] ?? {});
    if (reqRef != null) modelsToGenerateOriginal.add(reqRef);
  }

  final Set<String> finalModelsOriginalNames = {};
  void discover(String originalName) {
    if (finalModelsOriginalNames.contains(originalName)) return;
    finalModelsOriginalNames.add(originalName);

    final schema = schemas[originalName] ?? syntheticSchemas[originalName];
    if (schema != null) {
      final props = _resolveProperties(schema, schemas);
      props.forEach((key, value) {
        final ref = _getSchemaRefFromProp(value);
        if (ref != null) discover(ref);
      });
    }
  }

  modelsToGenerateOriginal.forEach(discover);

  // 3. Generate Models & Entities
  for (final originalName in finalModelsOriginalNames) {
    final schema = schemas[originalName] ?? syntheticSchemas[originalName];
    if (schema != null) {
      _generateModel(originalName, schema, '$baseDir/data/models', schemas);
      _generateEntity(
        originalName,
        schema,
        '$baseDir/domain/entities',
        schemas,
      );
    }
  }

  // 4. Generate Domain Layer
  _generateRepositoryInterface(
    targetTag,
    endpoints,
    '$baseDir/domain/repositories',
  );
  for (final endpoint in endpoints) {
    _generateUseCase(endpoint, '$baseDir/domain/usecases', targetTag);
  }

  // 5. Generate Data Layer
  _generateRemoteDataSource(targetTag, endpoints, '$baseDir/data/datasources');
  _generateRemoteDataSourceImpl(
    targetTag,
    endpoints,
    '$baseDir/data/datasources',
  );
  _generateRepositoryImpl(targetTag, endpoints, '$baseDir/data/repositories');

  print('✅ Feature $targetTag generated successfully in $baseDir');
}

class GeneratedEndpoint {
  final String path;
  final String method;
  final String methodName;
  final String returnTypeRaw; // Original Swagger Name
  final Map<String, dynamic> details;

  GeneratedEndpoint({
    required this.path,
    required this.method,
    required this.methodName,
    required this.returnTypeRaw,
    required this.details,
  });

  String get returnTypeModel => returnTypeRaw == 'dynamic'
      ? 'dynamic'
      : '${_cleanName(returnTypeRaw)}Model';
  String get returnTypeEntity => returnTypeRaw == 'dynamic'
      ? 'dynamic'
      : '${_cleanName(returnTypeRaw)}Entity';
}

void _createDirectories(String baseDir) {
  final dirs = [
    '$baseDir/data/datasources',
    '$baseDir/data/models',
    '$baseDir/data/repositories',
    '$baseDir/domain/entities',
    '$baseDir/domain/repositories',
    '$baseDir/domain/usecases',
    '$baseDir/presentation/bloc',
    '$baseDir/presentation/pages',
  ];
  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }
}

String _handleResponseSchemaRaw(
  Map<String, dynamic> details,
  String methodName,
  Map<String, Map<String, dynamic>> synthetic,
) {
  final responses = details['responses'] as Map<String, dynamic>?;
  final successRes = responses?['200'] ?? responses?['201'];
  if (successRes == null) return 'dynamic';

  final ref = _getSchemaRef(successRes);
  if (ref != null) return ref;

  final content = successRes['content'] as Map<String, dynamic>?;
  final schema =
      content?['application/json']?['schema'] as Map<String, dynamic>?;
  if (schema != null &&
      (schema['type'] == 'object' || schema.containsKey('properties'))) {
    final syntheticName = '${_capitalize(methodName)}Response';
    synthetic[syntheticName] = schema;
    return syntheticName;
  }

  return 'dynamic';
}

String? _getSchemaRef(Map<String, dynamic> container) {
  final content = container['content'] as Map<String, dynamic>?;
  final schema = content?['application/json']?['schema'] ?? container['schema'];
  if (schema == null) return null;

  if (schema['\$ref'] != null) {
    return (schema['\$ref'] as String).split('/').last;
  }
  if (schema['items'] != null && schema['items']['\$ref'] != null) {
    return (schema['items']['\$ref'] as String).split('/').last;
  }
  return null;
}

String? _getSchemaRefFromProp(Map<String, dynamic> prop) {
  if (prop['\$ref'] != null) return (prop['\$ref'] as String).split('/').last;
  if (prop['items'] != null && prop['items']['\$ref'] != null) {
    return (prop['items']['\$ref'] as String).split('/').last;
  }
  return null;
}

Map<String, dynamic> _resolveProperties(
  Map<String, dynamic> schema,
  Map<String, dynamic> allSchemas,
) {
  Map<String, dynamic> combined = {};

  if (schema.containsKey('allOf')) {
    final List<dynamic> allOf = schema['allOf'];
    for (final item in allOf) {
      if (item.containsKey('\$ref')) {
        final refName = (item['\$ref'] as String).split('/').last;
        final refSchema = allSchemas[refName];
        if (refSchema != null) {
          combined.addAll(_resolveProperties(refSchema, allSchemas));
        }
      } else if (item.containsKey('properties')) {
        combined.addAll(item['properties']);
      }
    }
  }

  if (schema.containsKey('properties')) {
    combined.addAll(schema['properties']);
  }

  return combined;
}

void _generateModel(
  String originalName,
  Map<String, dynamic> schema,
  String outputDir,
  Map<String, dynamic> allSchemas,
) {
  final cleanName = _cleanName(originalName);
  final fileName = _toSnakeCase(cleanName);
  final props = _resolveProperties(schema, allSchemas);
  final requiredFields =
      (schema['required'] as List<dynamic>?)?.cast<String>() ?? [];

  final Set<String> imports = {};
  props.forEach((key, value) {
    final ref = _getSchemaRefFromProp(value);
    if (ref != null && ref != originalName) {
      final refClean = _cleanName(ref);
      imports.add("import '${_toSnakeCase(refClean)}_model.dart';");
    }
  });

  StringBuffer body = StringBuffer();
  body.writeln("import 'package:freezed_annotation/freezed_annotation.dart';");
  body.writeln("import '../../domain/entities/${fileName}_entity.dart';");
  for (final imp in imports) {
    body.writeln(imp);
  }
  body.writeln();
  body.writeln("part '${fileName}_model.freezed.dart';");
  body.writeln("part '${fileName}_model.g.dart';");
  body.writeln();
  body.writeln("@freezed");
  body.writeln("class ${cleanName}Model with _\$${cleanName}Model {");
  body.writeln("  const factory ${cleanName}Model({");

  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (isRequired) {
      final defaultValue = _getDefaultValue(type);
      body.writeln("    @Default($defaultValue) $type $camelKey,");
    } else {
      body.writeln("     $type $camelKey,");
    }
  });

  body.writeln("  }) = _${cleanName}Model;");
  body.writeln();
  body.writeln(
    "  factory ${cleanName}Model.fromJson(Map<String, dynamic> json) => _\$${cleanName}ModelFromJson(json);",
  );
  body.writeln();
  body.writeln(
    "  factory ${cleanName}Model.fromEntity(${cleanName}Entity entity) {",
  );
  body.writeln("    return ${cleanName}Model(");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (type.contains('Model')) {
      if (type.startsWith('List')) {
        final modelType = type
            .replaceAll('List<', '')
            .replaceAll('>?', '')
            .replaceAll('>', '');
        body.writeln(
          "      $camelKey: entity.$camelKey?.map((e) => $modelType.fromEntity(e)).toList() ?? const [],",
        );
      } else {
        final modelType = type.replaceAll('?', '');
        if (isRequired) {
          body.writeln(
            "      $camelKey: $modelType.fromEntity(entity.$camelKey),",
          );
        } else {
          body.writeln(
            "      $camelKey: entity.$camelKey != null ? $modelType.fromEntity(entity.$camelKey!) : null,",
          );
        }
      }
    } else {
      body.writeln("      $camelKey: entity.$camelKey,");
    }
  });
  body.writeln("    );");
  body.writeln("  }");
  body.writeln();
  body.writeln("  const ${cleanName}Model._();");
  body.writeln();
  body.writeln("  ${cleanName}Entity toEntity() {");
  body.writeln("    return ${cleanName}Entity(");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (type.contains('Model')) {
      if (type.startsWith('List')) {
        body.writeln(
          "      $camelKey: $camelKey?.map((e) => e.toEntity()).toList() ?? const [],",
        );
      } else {
        if (isRequired) {
          body.writeln("      $camelKey: $camelKey.toEntity(),");
        } else {
          body.writeln("      $camelKey: $camelKey?.toEntity(),");
        }
      }
    } else {
      body.writeln("      $camelKey: $camelKey,");
    }
  });
  body.writeln("    );");
  body.writeln("  }");
  body.writeln("}");

  File('$outputDir/${fileName}_model.dart').writeAsStringSync(body.toString());
}

String _getDefaultValue(String type) {
  if (type.startsWith('List')) return 'const []';
  if (type.startsWith('String')) return "''";
  if (type.startsWith('num') || type.startsWith('int')) return '0';
  if (type.startsWith('bool')) return 'false';
  if (type.contains('Model')) {
    final clean = type.replaceAll('?', '');
    return 'const $clean()';
  }
  return 'null';
}

void _generateEntity(
  String originalName,
  Map<String, dynamic> schema,
  String outputDir,
  Map<String, dynamic> allSchemas,
) {
  final cleanName = _cleanName(originalName);
  final fileName = _toSnakeCase(cleanName);
  final props = _resolveProperties(schema, allSchemas);
  final requiredFields =
      (schema['required'] as List<dynamic>?)?.cast<String>() ?? [];

  final Set<String> imports = {};
  props.forEach((key, value) {
    final ref = _getSchemaRefFromProp(value);
    if (ref != null && ref != originalName) {
      final refClean = _cleanName(ref);
      imports.add("import '${_toSnakeCase(refClean)}_entity.dart';");
    }
  });

  StringBuffer body = StringBuffer();
  for (final imp in imports) {
    body.writeln(imp);
  }
  body.writeln();
  body.writeln("class ${cleanName}Entity {");

  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Entity', isRequired: isRequired);
    body.writeln("  final $type $camelKey;");
  });

  body.writeln();
  body.writeln("  const ${cleanName}Entity({");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    body.writeln("    this.$camelKey,");
  });
  body.writeln("  });");
  body.writeln("}");

  File('$outputDir/${fileName}_entity.dart').writeAsStringSync(body.toString());
}

void _generateUseCase(
  GeneratedEndpoint endpoint,
  String outputDir,
  String featureTag,
) {
  final ucName = '${_capitalize(endpoint.methodName)}UseCase';
  final fileName = '${_toSnakeCase(endpoint.methodName)}_usecase.dart';
  final repoName = '${featureTag}Repository';
  final repoFileName = '${_toSnakeCase(featureTag)}_repository.dart';
  final entityName = endpoint.returnTypeEntity;

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/api_result.dart';");
  body.writeln("import '../repositories/$repoFileName';");
  if (endpoint.returnTypeRaw != 'dynamic') {
    body.writeln(
      "import '../entities/${_toSnakeCase(_cleanName(endpoint.returnTypeRaw))}_entity.dart';",
    );
  }
  body.writeln();
  body.writeln("class $ucName {");
  body.writeln("  final $repoName _repository;");
  body.writeln();
  body.writeln("  $ucName(this._repository);");
  body.writeln();
  body.writeln("  Future<ApiResult<$entityName>> call() async {");
  body.writeln("    return await _repository.${endpoint.methodName}();");
  body.writeln("  }");
  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRepositoryInterface(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}Repository';
  final fileName = '${_toSnakeCase(feature)}_repository.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/api_result.dart';");

  final Set<String> neededRawNames = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededRawNames.add(ep.returnTypeRaw);
  }
  for (final raw in neededRawNames) {
    body.writeln(
      "import '../entities/${_toSnakeCase(_cleanName(raw))}_entity.dart';",
    );
  }

  body.writeln();
  body.writeln("abstract class $name {");

  for (final ep in endpoints) {
    body.writeln(
      "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}();",
    );
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRemoteDataSource(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();
  final Set<String> neededModels = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededModels.add(ep.returnTypeRaw);
  }
  for (final raw in neededModels) {
    body.writeln(
      "import '../models/${_toSnakeCase(_cleanName(raw))}_model.dart';",
    );
  }

  body.writeln();
  body.writeln("abstract class $name {");

  for (final ep in endpoints) {
    body.writeln("  Future<${ep.returnTypeModel}> ${ep.methodName}();");
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRemoteDataSourceImpl(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RemoteDataSourceImpl';
  final interfaceName = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_remote_datasource_impl.dart';
  final interfaceFileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/dio_client.dart';");
  body.writeln("import '$interfaceFileName';");

  final Set<String> neededModels = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededModels.add(ep.returnTypeRaw);
  }
  for (final raw in neededModels) {
    body.writeln(
      "import '../models/${_toSnakeCase(_cleanName(raw))}_model.dart';",
    );
  }

  body.writeln();
  body.writeln("class $name implements $interfaceName {");
  body.writeln("  final DioClient _dioClient;");
  body.writeln();
  body.writeln("  $name(this._dioClient);");

  for (final ep in endpoints) {
    body.writeln();
    body.writeln("  @override");
    body.writeln("  Future<${ep.returnTypeModel}> ${ep.methodName}() async {");
    body.writeln(
      "    final response = await _dioClient.${ep.method}('${ep.path}');",
    );
    if (ep.returnTypeRaw == 'dynamic') {
      body.writeln("    return response.data;");
    } else {
      body.writeln("    if (response.data == null) {");
      if (ep.returnTypeModel.startsWith('List')) {
        body.writeln("      return const [];");
      } else {
        body.writeln("      return const ${ep.returnTypeModel}();");
      }
      body.writeln("    }");
      body.writeln("    return ${ep.returnTypeModel}.fromJson(response.data);");
    }
    body.writeln("  }");
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRepositoryImpl(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RepositoryImpl';
  final interfaceName = '${feature}Repository';
  final dsName = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_repository_impl.dart';
  final interfaceFileName = '${_toSnakeCase(feature)}_repository.dart';
  final dsFileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/failures.dart';");
  body.writeln("import '../../../../core/network/api_result.dart';");
  body.writeln("import '../../domain/repositories/$interfaceFileName';");
  body.writeln("import '../datasources/$dsFileName';");

  final Set<String> neededRawNames = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededRawNames.add(ep.returnTypeRaw);
  }
  for (final raw in neededRawNames) {
    body.writeln(
      "import '../../domain/entities/${_toSnakeCase(_cleanName(raw))}_entity.dart';",
    );
  }

  body.writeln();
  body.writeln("class $name implements $interfaceName {");
  body.writeln("  final $dsName _remoteDataSource;");
  body.writeln();
  body.writeln("  $name(this._remoteDataSource);");

  for (final ep in endpoints) {
    body.writeln();
    body.writeln("  @override");
    body.writeln(
      "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}() async {",
    );
    body.writeln("    try {");
    body.writeln(
      "      final result = await _remoteDataSource.${ep.methodName}();",
    );
    if (ep.returnTypeRaw == 'dynamic') {
      body.writeln("      return ApiResult.success(result);");
    } else {
      body.writeln("      return ApiResult.success(result.toEntity());");
    }
    body.writeln("    } catch (e) {");
    body.writeln(
      "      return ApiResult.failure(ServerFailure(e.toString()));",
    );
    body.writeln("    }");
    body.writeln("  }");
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

String _cleanPathSegment(String segment) {
  return segment.replaceAll('{', '').replaceAll('}', '');
}

String _cleanName(String name) {
  return name.replaceAll('DTO', '').replaceAll('Dto', '');
}

String _sanitizeKey(String key) {
  return key
      .replaceAll(RegExp(r'[^\w]'), '_')
      .replaceAll('{', '')
      .replaceAll('}', '');
}

String _toCamelCase(String text) {
  if (text.isEmpty) return text;
  final parts = text.split(RegExp(r'[_-\s]'));
  if (parts.length == 1 && parts[0] == parts[0].toLowerCase()) return parts[0];

  final first = parts[0].toLowerCase();
  final rest = parts.sublist(1).map(_capitalize).join('');
  return '$first$rest';
}

String _getDartType(
  Map<String, dynamic> prop, {
  String suffix = '',
  bool isRequired = false,
}) {
  final nullableSuffix = isRequired ? '' : '?';

  if (prop.containsKey('\$ref')) {
    final ref = (prop['\$ref'] as String).split('/').last;
    final cleanRef = _cleanName(ref);
    return '$cleanRef$suffix$nullableSuffix';
  }

  final type = prop['type'];
  switch (type) {
    case 'string':
      return 'String$nullableSuffix';
    case 'number':
      return 'num$nullableSuffix';
    case 'integer':
      return 'int$nullableSuffix';
    case 'boolean':
      return 'bool$nullableSuffix';
    case 'array':
      final items = prop['items'] as Map<String, dynamic>?;
      if (items != null && items.containsKey('\$ref')) {
        final ref = (items['\$ref'] as String).split('/').last;
        final cleanRef = _cleanName(ref);
        return 'List<$cleanRef$suffix>$nullableSuffix';
      }
      return 'List<dynamic>$nullableSuffix';
    default:
      return 'dynamic';
  }
}

String _toSnakeCase(String text) {
  return text
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '_${match.group(1)!.toLowerCase()}',
      )
      .toLowerCase()
      .replaceAll(RegExp(r'^_'), '');
}

String _capitalize(String text) =>
    text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);
