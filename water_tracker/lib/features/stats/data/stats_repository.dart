import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/water/data/water_repository.dart';

class StatsRepository {
  StatsRepository(this._client);

  final SupabaseClient _client;

  WaterRepository get _water => WaterRepository(_client);

  static DateTime _dayOnly(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  /// Список из [n] дат, первая — (n−1) дней назад, последняя — [anchorDay].
  static List<DateTime> _lastNDaysFrom(DateTime anchorDay, int n) {
    final DateTime a = _dayOnly(anchorDay);
    return List<DateTime>.generate(
      n,
      (int i) => a.subtract(Duration(days: n - 1 - i)),
    );
  }

  static Map<DateTime, int> _fillRange(
    Map<DateTime, int> raw,
    List<DateTime> dayKeys,
  ) {
    final Map<DateTime, int> out = <DateTime, int>{};
    for (final DateTime d in dayKeys) {
      out[d] = raw[d] ?? 0;
    }
    return out;
  }

  /// Последние 7 календарных дней, включая сегодня (local).
  Future<Map<DateTime, int>> getWeeklyStats() async {
    final DateTime end = _dayOnly(DateTime.now());
    final DateTime start = end.subtract(const Duration(days: 6));
    final Map<DateTime, int> raw = await _water.getStatsRange(start, end);
    return _fillRange(raw, _lastNDaysFrom(end, 7));
  }

  /// Последние 30 дней, включая сегодня.
  Future<Map<DateTime, int>> getMonthlyStats() async {
    final DateTime end = _dayOnly(DateTime.now());
    final DateTime start = end.subtract(const Duration(days: 29));
    final Map<DateTime, int> raw = await _water.getStatsRange(start, end);
    return _fillRange(raw, _lastNDaysFrom(end, 30));
  }

  /// Сколько дней подряд, начиная с сегодня назад, при total >= [dailyGoalMl].
  Future<int> getCurrentStreak(int dailyGoalMl) async {
    final DateTime today = _dayOnly(DateTime.now());
    final DateTime from = today.subtract(const Duration(days: 500));
    final Map<DateTime, int> raw = await _water.getStatsRange(from, today);
    int streak = 0;
    for (int i = 0; i < 500; i++) {
      final DateTime d = today.subtract(Duration(days: i));
      final int v = raw[d] ?? 0;
      if (v >= dailyGoalMl) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
