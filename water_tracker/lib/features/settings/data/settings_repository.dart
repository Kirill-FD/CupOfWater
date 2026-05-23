import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/domain/models/user_profile.dart';

const String _kCachedProfilePrefix = 'cached_profile_v1_';

class SettingsRepository {
  SettingsRepository(this._client);

  final SupabaseClient _client;

  Future<void> _cacheProfile(UserProfile profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_kCachedProfilePrefix${profile.id}',
      json.encode(profile.toJson()),
    );
  }

  Future<UserProfile?> _readCachedProfile(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString('$_kCachedProfilePrefix$id');
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      return UserProfile.fromJson(
        Map<String, dynamic>.from(json.decode(raw) as Map<dynamic, dynamic>),
      );
    } on Object {
      return null;
    }
  }

  Map<String, dynamic> _defaultProfile(String id) {
    return <String, dynamic>{
      'id': id,
      'display_name': null,
      'daily_goal_ml': 2000,
      'reminder_enabled': true,
      'reminder_interval_minutes': 60,
      'reminder_start_time': '09:00:00',
      'reminder_end_time': '22:00:00',
      'timezone': 'UTC',
    };
  }

  /// Для [reminder_*] в Supabase должны существовать соответствующие колонки
  /// в [profiles], иначе [update] вернёт ошибку.
  Future<UserProfile> getProfile() async {
    final String? id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('Not authenticated');
    }
    try {
      final PostgrestMap? existing = await _client
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (existing != null) {
        final UserProfile profile = UserProfile.fromJson(existing);
        await _cacheProfile(profile);
        return profile;
      }
      final Map<String, dynamic> created = _defaultProfile(id);
      await _client.from('profiles').upsert(created, onConflict: 'id');
      final PostgrestMap row = await _client
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      final UserProfile profile = UserProfile.fromJson(row);
      await _cacheProfile(profile);
      return profile;
    } on Object {
      final UserProfile? cached = await _readCachedProfile(id);
      if (cached != null) {
        return cached;
      }
      return UserProfile.fromJson(_defaultProfile(id));
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    final String? id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('Not authenticated');
    }
    final PostgrestMap? updated = await _client
        .from('profiles')
        .update(updates)
        .eq('id', id)
        .select()
        .maybeSingle();
    if (updated != null) {
      final UserProfile profile = UserProfile.fromJson(updated);
      await _cacheProfile(profile);
      return profile;
    }
    final PostgrestMap saved = await _client
        .from('profiles')
        .upsert(<String, dynamic>{
          ..._defaultProfile(id),
          ...updates,
          'id': id,
        }, onConflict: 'id')
        .select()
        .single();
    final UserProfile profile = UserProfile.fromJson(saved);
    await _cacheProfile(profile);
    return profile;
  }
}
