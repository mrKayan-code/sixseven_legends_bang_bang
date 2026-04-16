class CsvParser {
  static List<Map<String, String>> parse(String csvText) {
    final List<Map<String, String>> result = [];

    final lines = csvText.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) return result;

    final headers = lines.first.split(',').map((e) => e.trim()).toList();

    for (int i = 1; i < lines.length; i++) {
      final values = lines[i].split(',').map((e) => e.trim()).toList();

      if (values.length != headers.length) continue;

      final Map<String, String> row = {};
      for (int j = 0; j < headers.length; j++) {
        row[headers[j]] = values[j];
      }
      result.add(row);
    }

    return result;
  }

  static List<String> getFeatures(String csvText, String targetColumn) {
    final lines = csvText.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) return [];

    final headers = lines.first.split(',').map((e) => e.trim()).toList();
    headers.remove(targetColumn);

    return headers;
  }
}