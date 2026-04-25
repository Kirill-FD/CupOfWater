/// Значения задаются только через `--dart-define` при сборке (см. README).
class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Явная проверка (не [assert]): в release AOT assert отключён, иначе пустые
  /// ключи проходят бы незаметно.
  static void validate() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Задайте SUPABASE_URL и SUPABASE_ANON_KEY через --dart-define при '
        'сборке/запуске. Пример:\n'
        '  flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co '
        '--dart-define=SUPABASE_ANON_KEY=eyJ...',
      );
    }
  }
}
