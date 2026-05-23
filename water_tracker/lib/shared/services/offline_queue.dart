// Очередь addIntake: JSON в shared_preferences, сброс при сети.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:water_tracker/core/error/app_logger.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';

const String _kKey = 'offline_intake_queue_v1';

@immutable
class QueuedIntake {
  const QueuedIntake({required this.amountMl, required this.createdAtMs});

  final int amountMl;
  final int createdAtMs;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'ml': amountMl, 'at': createdAtMs};
  }

  static QueuedIntake fromMap(Map<String, dynamic> m) {
    return QueuedIntake(
      amountMl: (m['ml'] as num).toInt(),
      createdAtMs: (m['at'] as num).toInt(),
    );
  }
}

class OfflineQueue {
  static Future<OfflineQueue> get instance async {
    return OfflineQueue._(await SharedPreferences.getInstance());
  }

  OfflineQueue._(this._p);

  final SharedPreferences _p;

  List<QueuedIntake> _decode() {
    final String? s = _p.getString(_kKey);
    if (s == null || s.isEmpty) {
      return <QueuedIntake>[];
    }
    try {
      final List<dynamic> list = json.decode(s) as List<dynamic>;
      return list
          .map(
            (e) => QueuedIntake.fromMap(
              Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
            ),
          )
          .toList();
    } on Object {
      return <QueuedIntake>[];
    }
  }

  Future<void> _encode(List<QueuedIntake> q) async {
    final String s = json.encode(q.map((QueuedIntake e) => e.toMap()).toList());
    await _p.setString(_kKey, s);
  }

  /// Добавить в очередь, если addIntake не ушло в сеть.
  Future<void> enqueueAddIntake(int amountMl) async {
    final List<QueuedIntake> list = _decode()
      ..add(
        QueuedIntake(
          amountMl: amountMl,
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    await _encode(list);
  }

  Future<int> get pendingCount async => _decode().length;

  /// Отправить в Supabase по порядку, очистить удачно отправленные.
  Future<int> flush(SupabaseClient client) async {
    final List<QueuedIntake> all = _decode();
    if (all.isEmpty) {
      return 0;
    }
    final WaterRepository repo = WaterRepository(client);
    final List<QueuedIntake> remaining = <QueuedIntake>[];
    for (final QueuedIntake q in all) {
      try {
        await repo.addIntake(q.amountMl);
      } on Object catch (e, s) {
        logAppError('OfflineQueue', e, s);
        remaining
          ..add(q)
          ..addAll(all.skip(all.indexOf(q) + 1));
        break;
      }
    }
    await _encode(remaining);
    return all.length - remaining.length;
  }
}
