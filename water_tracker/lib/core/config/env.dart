class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static void validate() {
    assert(supabaseUrl.isNotEmpty, 'SUPABASE_URL is required');
    assert(supabaseAnonKey.isNotEmpty, 'SUPABASE_ANON_KEY is required');
  }
}
