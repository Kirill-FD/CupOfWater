import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/core/config/env.dart';

class SupabaseConfig {
  static Future<void> init() async {
    Env.validate();
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
