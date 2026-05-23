import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String _kProfileUpdatesKey = 'offline_profile_updates_v1';

class ProfileUpdateQueue {
  static Future<ProfileUpdateQueue> get instance async {
    return ProfileUpdateQueue._(await SharedPreferences.getInstance());
  }

  ProfileUpdateQueue._(this._prefs);

  final SharedPreferences _prefs;

  Map<String, dynamic> _decode() {
    final String? raw = _prefs.getString(_kProfileUpdatesKey);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      return Map<String, dynamic>.from(
        json.decode(raw) as Map<dynamic, dynamic>,
      );
    } on Object {
      return <String, dynamic>{};
    }
  }

  Future<void> _encode(Map<String, dynamic> updates) async {
    if (updates.isEmpty) {
      await _prefs.remove(_kProfileUpdatesKey);
      return;
    }
    await _prefs.setString(_kProfileUpdatesKey, json.encode(updates));
  }

  Future<void> enqueue(Map<String, dynamic> updates) async {
    await _encode(<String, dynamic>{..._decode(), ...updates});
  }

  Future<bool> flush(SupabaseClient client) async {
    final Map<String, dynamic> updates = _decode();
    if (updates.isEmpty) {
      return false;
    }
    final String? id = client.auth.currentUser?.id;
    if (id == null) {
      return false;
    }
    final PostgrestMap? saved = await client
        .from('profiles')
        .update(updates)
        .eq('id', id)
        .select()
        .maybeSingle();
    if (saved == null) {
      await client.from('profiles').upsert(<String, dynamic>{
        'id': id,
        'display_name': null,
        'daily_goal_ml': 2000,
        'reminder_enabled': true,
        'reminder_interval_minutes': 60,
        'reminder_start_time': '09:00:00',
        'reminder_end_time': '22:00:00',
        'timezone': 'UTC',
        ...updates,
      }, onConflict: 'id');
    }
    await _encode(<String, dynamic>{});
    return true;
  }
}
