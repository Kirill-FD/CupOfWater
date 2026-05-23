class InputSanitizer {
  InputSanitizer._();

  // Remove control characters that should never be sent in regular text inputs.
  static final RegExp _controlChars = RegExp(r'[\u0000-\u001F\u007F]');
  static final RegExp _multiSpace = RegExp(r'\s{2,}');

  static String normalizeEmail(String raw) {
    return raw.trim().toLowerCase().replaceAll(_controlChars, '');
  }

  static String sanitizeDisplayName(String raw, {int maxLength = 60}) {
    final String cleaned = raw
        .replaceAll(_controlChars, '')
        .replaceAll(_multiSpace, ' ')
        .trim();
    if (cleaned.length <= maxLength) {
      return cleaned;
    }
    return cleaned.substring(0, maxLength).trim();
  }
}
