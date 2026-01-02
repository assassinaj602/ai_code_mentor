abstract class LlmService {
  Future<Map<String, dynamic>> analyzeCode({
    required String code,
    required String logs,
    required String focus,
  });

  String sanitizeJson(String input) {
    String cleaned = input.trim();

    // Remove markdown code blocks
    // 0. Remove markdown wrapping first
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.replaceFirst('```json', '').trim();
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst('```', '').trim();
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3).trim();
    }

    // 1. Attempt to fix Python-style triple quotes """ ... """
    // This is a common issue with some models generating Python dicts instead of JSON
    final tripleQuoteRegex = RegExp(r'"""(.*?)"""', dotAll: true);
    cleaned = cleaned.replaceAllMapped(tripleQuoteRegex, (match) {
      String content = match.group(1) ?? '';
      // Escape generic newlines and quotes inside the content
      String escaped = content
          .replaceAll('\\', '\\\\') // Escape backslashes first
          .replaceAll('"', '\\"') // Escape double quotes
          .replaceAll('\n', '\\n') // Escape newlines
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return '"$escaped"';
    });

    // 2. Locate JSON bounds
    final startIndex = cleaned.indexOf('{');
    final endIndex = cleaned.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      cleaned = cleaned.substring(startIndex, endIndex + 1);
    }

    // 3. Fix unescaped control characters within standard string literals
    // This regex looks for content inside double quotes
    final stringLiteralRegex = RegExp(r'"((?:[^"\\]|\\.)*)"', dotAll: true);

    cleaned = cleaned.replaceAllMapped(stringLiteralRegex, (match) {
      String content = match.group(1) ?? '';
      // If the content already has escaped characters, we might be double escaping if we are not careful
      // But mainly we want to catch raw newlines that are NOT escaped

      if (content.contains('\n') ||
          content.contains('\r') ||
          content.contains('\t')) {
        String escaped = content
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r')
            .replaceAll('\t', '\\t');
        return '"$escaped"';
      }
      return match.group(0)!;
    });

    return cleaned;
  }
}
