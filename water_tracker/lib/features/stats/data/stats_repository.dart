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
  Future<Map<DateTime, int>> getWeeklyStats({required String timezone}) async {
    final DateTime end = _dayOnly(DateTime.now());
    final DateTime start = end.subtract(const Duration(days: 6));
    final Map<DateTime, int> raw = await _water.getStatsRange(
      start,
      end,
      timezone: timezone,
    );
    return _fillRange(raw, _lastNDaysFrom(end, 7));
  }

  /// Последние 30 дней, включая сегодня.
  Future<Map<DateTime, int>> getMonthlyStats({required String timezone}) async {
    final DateTime end = _dayOnly(DateTime.now());
    final DateTime start = end.subtract(const Duration(days: 29));
    final Map<DateTime, int> raw = await _water.getStatsRange(
      start,
      end,
      timezone: timezone,
    );
    return _fillRange(raw, _lastNDaysFrom(end, 30));
  }

  /// Все дни календарного месяца [year]/[month] с нулями для пустых.
  Future<Map<DateTime, int>> getCalendarMonthStats({
    required int year,
    required int month,
    required String timezone,
  }) async {
    final DateTime first = DateTime(year, month, 1);
    final DateTime last = DateTime(year, month + 1, 0);
    final Map<DateTime, int> raw = await _water.getStatsRange(
      first,
      last,
      timezone: timezone,
    );
    final List<DateTime> keys = List<DateTime>.generate(
      last.day,
      (int i) => DateTime(year, month, i + 1),
    );
    return _fillRange(raw, keys);
  }

  /// Каждый день года [year] (для агрегации по месяцам).
  Future<Map<DateTime, int>> getYearDailyStats({
    required int year,
    required String timezone,
  }) async {
    final DateTime first = DateTime(year, 1, 1);
    final DateTime last = DateTime(year, 12, 31);
    final Map<DateTime, int> raw = await _water.getStatsRange(
      first,
      last,
      timezone: timezone,
    );
    final List<DateTime> keys = <DateTime>[];
    for (
      DateTime d = first;
      !d.isAfter(last);
      d = d.add(const Duration(days: 1))
    ) {
      keys.add(DateTime(d.year, d.month, d.day));
    }
    return _fillRange(raw, keys);
  }

  /// Суммы по месяцам 1..12 для [year].
  Future<Map<int, int>> getMonthlyTotalsForYear({
    required int year,
    required String timezone,
  }) async {
    final Map<DateTime, int> daily =
        await getYearDailyStats(year: year, timezone: timezone);
    final Map<int, int> out = <int, int>{};
    for (final MapEntry<DateTime, int> e in daily.entries) {
      if (e.key.year != year) {
        continue;
      }
      final int m = e.key.month;
      out[m] = (out[m] ?? 0) + e.value;
    }
    return out;
  }

  /// Неделя со смещением: 0 — текущая ISO-подобная 7 дней до сегодня (как [getWeeklyStats]).
  Future<Map<DateTime, int>> getWeekStatsEnding({
    required DateTime endDay,
    required String timezone,
  }) async {
    final DateTime end = _dayOnly(endDay);
    final Map<DateTime, int> raw = await _water.getStatsRange(
      end.subtract(const Duration(days: 6)),
      end,
      timezone: timezone,
    );
    return _fillRange(raw, _lastNDaysFrom(end, 7));
  }

  Future<({int sumMl, int activeDays})> getRangeTotals({
    required DateTime start,
    required DateTime end,
    required String timezone,
  }) async {
    final DateTime s = _dayOnly(start);
    final DateTime e = _dayOnly(end);
    final Map<DateTime, int> m = await _water.getStatsRange(
      s,
      e,
      timezone: timezone,
    );
    int sum = 0;
    int active = 0;
    for (final int v in m.values) {
      sum += v;
      if (v > 0) {
        active++;
      }
    }
    return (sumMl: sum, activeDays: active);
  }

  /// Сколько дней подряд, начиная с сегодня назад, при total >= [dailyGoalMl].
  Future<int> getCurrentStreak(
    int dailyGoalMl, {
    required String timezone,
  }) async {
    final DateTime today = _dayOnly(DateTime.now());
    final DateTime from = today.subtract(const Duration(days: 500));
    final Map<DateTime, int> raw = await _water.getStatsRange(
      from,
      today,
      timezone: timezone,
    );
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
