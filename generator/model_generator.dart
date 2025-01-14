import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc_skeleton/app/core/utils/typedf/index.dart';

String generateModelFromJson(String className, JsonMap jsonObject) {
  final buffer = StringBuffer();

  // class definition
  buffer.writeln('class $className {');

  /// Helper function to determine the Dart type from a JSON value.
  String getType(dynamic value) {
    if (value is int) {
      return 'int';
    } else if (value is double) {
      return 'double';
    } else if (value is bool) {
      return 'bool';
    } else if (value is String) {
      return 'String';
    } else if (value is List) {
      if (value.isNotEmpty) {
        return 'List<${getType(value.first)}>';
      } else {
        return 'List<dynamic>';
      }
    } else if (value is Map) {
      return 'Map<String, dynamic>';
    } else {
      return 'dynamic';
    }
  }

  // generate fields
  jsonObject.forEach((key, value) {
    buffer.writeln('  final ${getType(value)} $key;');
  });

  // constructor
  buffer.writeln('\n  $className({');
  jsonObject.forEach((key, _) {
    buffer.writeln('    required this.$key,');
  });
  buffer.writeln('  });');

// Factory constructor for JSON deserialization
  buffer
      .writeln('\n  factory $className.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  jsonObject.forEach((key, value) {
    buffer.writeln('      $key: json[\'$key\'] as ${getType(value)},');
  });
  buffer.writeln('    );');
  buffer.writeln('  }');

  // Method for JSON serialization
  buffer.writeln('\n  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  jsonObject.forEach((key, _) {
    buffer.writeln('      \'$key\': $key,');
  });
  buffer.writeln('    };');
  buffer.writeln('  }');

  // End class definition
  buffer.writeln('}');

  return buffer.toString();
}

void main() {
  // Ask for the model name
  stdout.write('Enter the model name:');
  final className = stdin.readLineSync() ?? 'UnnamedM';

  // Ask for JSON input
  stdout.write('Enter the JSON object: ');
  final jsonString = stdin.readLineSync() ?? '{}';
  // ignore: avoid_print
  print(jsonString);

  try {
    // Parse JSON string to Map
    final jsonData = jsonDecode(jsonString);
    final model = generateModelFromJson('${className}M', jsonData);

    final classPath = className.toLowerCase();
    final outputPath = '../lib/app/models/$classPath/index.dart';

    // Create directory if it doesn't exist
    final directory = Directory('../lib/app/models/$classPath');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Write model to file
    final file = File(outputPath);
    file.writeAsStringSync(model);

    // ignore: avoid_print
    print('\n\nModel successfully written to $outputPath');
  } catch (e) {
    // ignore: avoid_print
    print('\n\nInvalid JSON input. Please try again.');
  }
}
