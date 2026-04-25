import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/domain/models/user_profile.dart';

class SettingsRepository {
  SettingsRepository(this._client);

  final SupabaseClient _client;

  /// Для [reminder_*] в Supabase должны существовать соответствующие колонки
  /// в [profiles], иначе [update] вернёт ошибку.
  Future<UserProfile> getProfile() async {
    final String? id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('Not authenticated');
    }
    final PostgrestMap row = await _client.from('profiles').select().eq('id', id).single();
    return UserProfile.fromJson(row);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    final String? id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('Not authenticated');
    }
    await _client.from('profiles').update(updates).eq('id', id);
    return getProfile();
  }
}
