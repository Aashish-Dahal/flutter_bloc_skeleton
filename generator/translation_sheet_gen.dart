// ignore_for_file: avoid_print
import 'dart:convert' show JsonEncoder;
import 'dart:io';

import 'package:gsheets/gsheets.dart' show GSheets;

void main() async {
  final file = File('../google_sheet.json');
  if (!file.existsSync()) {
    throw Exception("❌ Service account JSON not found!");
  }
  final contents = await file.readAsString();

  print("✅ Service account key loaded");

  print('🔐 Connecting to Google Sheets...');

  final translationSheet = GSheets(contents);

  final ss = await translationSheet.spreadsheet(
    '1x8Tk20ZheNAmvG6HJu3qzqxK5IgtcyacHe0HMetqBbE',
  );

  print('📒 Spreadsheet loaded');

  final Map<String, Map<String, String>> enJson = {};
  final Map<String, Map<String, String>> jaJson = {};

  for (final sheet in ss.sheets) {
    final sheetTitle = sheet.title;
    print('📄 Processing sheet: $sheetTitle');
    final rows = await sheet.values.allRows();
    if (rows.length < 2) {
      print('⚠️ Skipping "$sheetTitle": no data or only header');
      continue;
    }

    final Map<String, String> enSection = {};
    final Map<String, String> jaSection = {};

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length >= 4) {
        final key = row[1].trim();
        final en = row[2].trim();
        final ja = row[3].trim();

        if (key.isNotEmpty) {
          enSection[key] = en;
          jaSection[key] = ja;
        }
      }
    }

    enJson[sheetTitle] = enSection;
    jaJson[sheetTitle] = jaSection;

    print('✅ Completed: $sheetTitle (${enSection.length} keys)');
  }

  final dir = Directory('../assets/translations');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  final enPath = '${dir.path}/en.json';
  final jaPath = '${dir.path}/ja.json';

  await File(
    enPath,
  ).writeAsString(JsonEncoder.withIndent('  ').convert(enJson));
  await File(
    jaPath,
  ).writeAsString(JsonEncoder.withIndent('  ').convert(jaJson));

  print('🎉 Translations exported successfully!');
  print('📤 EN: $enPath');
  print('📤 JA: $jaPath');
}
