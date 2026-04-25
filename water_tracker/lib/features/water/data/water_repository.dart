import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/water/domain/models/water_intake.dart';

// Таблица: колонка consumed_at; RPC get_today_intake(p_user_id uuid),
// get_stats_range(p_start date, p_end date, p_tz text, p_user_id uuid).

class WaterRepository {
  WaterRepository(this._client);

  final SupabaseClient _client;

  String get _userId {
    final String? id = _client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('User is not signed in');
    }
    return id;
  }

  static DateTime _startOfLocalDay() {
    final DateTime n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  String _toDateString(DateTime d) {
    final String m = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  String _normalizeTimezone(String timezone) {
    final String trimmed = timezone.trim();
    return trimmed.isEmpty ? 'UTC' : trimmed;
  }

  Future<List<WaterIntake>> getTodayIntakes() async {
    final DateTime start = _startOfLocalDay();
    final PostgrestList data = await _client
        .from('water_intakes')
        .select()
        .eq('user_id', _userId)
        .gte('consumed_at', start.toIso8601String())
        .order('consumed_at', ascending: false);
    return data.map((PostgrestMap e) => WaterIntake.fromJson(e)).toList();
  }

  /// [get_today_intake] в Postgrest — с параметром `p_user_id` (см. миграцию).
  Future<int> getTodayTotal() async {
    final Object? res = await _client.rpc<dynamic>(
      'get_today_intake',
      params: <String, dynamic>{'p_user_id': _userId},
    );
    if (res is int) {
      return res;
    }
    if (res is num) {
      return res.toInt();
    }
    final String s = res?.toString() ?? '0';
    return int.parse(s, radix: 10);
  }

  Future<WaterIntake> addIntake(int amountMl) async {
    final String uid = _userId;
    final DateTime now = DateTime.now();
    final PostgrestMap row = await _client
        .from('water_intakes')
        .insert(<String, dynamic>{
          'user_id': uid,
          'amount_ml': amountMl,
          'consumed_at': now.toIso8601String(),
          'created_at': now.toIso8601String(),
        })
        .select()
        .single();
    return WaterIntake.fromJson(row);
  }

  Future<void> deleteIntake(String id) async {
    await _client.from('water_intakes').delete().eq('id', id);
  }

  Future<Map<DateTime, int>> getStatsRange(
    DateTime start,
    DateTime end, {
    required String timezone,
  }) async {
    final String pStart = _toDateString(
      DateTime(start.year, start.month, start.day),
    );
    final String pEnd = _toDateString(DateTime(end.year, end.month, end.day));
    final Object? raw = await _client.rpc<dynamic>(
      'get_stats_range',
      params: <String, dynamic>{
        'p_start': pStart,
        'p_end': pEnd,
        'p_tz': _normalizeTimezone(timezone),
        'p_user_id': _userId,
      },
    );
    if (raw is! List) {
      return <DateTime, int>{};
    }
    final Map<DateTime, int> out = <DateTime, int>{};
    for (final Object? item in raw) {
      if (item is! Map) {
        continue;
      }
      final Map<dynamic, dynamic> m = item;
      final Object? day = m['day'];
      final Object? total = m['total_ml'];
      if (day == null || total == null) {
        continue;
      }
      final DateTime d = DateTime.parse(day.toString().split('T').first);
      final int v = total is int ? total : (total as num).toInt();
      out[DateTime(d.year, d.month, d.day)] = v;
    }
    return out;
  }

  /// Один [eq]-фильтр на stream; сегодняшние записи отсекаем в [map].
  Stream<List<WaterIntake>> watchTodayIntakes() {
    final String uid = _userId;
    final DateTime start = _startOfLocalDay();
    return _client
        .from('water_intakes')
        .stream(primaryKey: <String>['id'])
        .eq('user_id', uid)
        .order('consumed_at', ascending: false)
        .map((List<Map<String, dynamic>> event) {
          final List<WaterIntake> all = event
              .map((Map<String, dynamic> m) => WaterIntake.fromJson(m))
              .where((WaterIntake i) => !i.consumedAt.isBefore(start))
              .toList();
          all.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
          return all;
        });
  }
}
