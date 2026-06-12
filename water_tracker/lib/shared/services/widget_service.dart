import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:home_widget/home_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, User;

import 'package:water_tracker/core/config/supabase_config.dart';
import 'package:water_tracker/shared/services/offline_queue.dart';

@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) {
  return WidgetService.backgroundCallback(uri);
}

class WidgetService {
  WidgetService._();
  static const String _widgetName = 'WaterWidget';
  static const String _iosWidgetName = 'WaterWidget';
  static const String _appGroupId = 'group.com.mycompany.watertracker';

  static bool _inited = false;

  static String todayDateKey([DateTime? at]) {
    final DateTime n = at ?? DateTime.now();
    final String month = n.month.toString().padLeft(2, '0');
    final String day = n.day.toString().padLeft(2, '0');
    return '${n.year}-$month-$day';
  }

  static Future<void> init() async {
    if (_inited) {
      return;
    }
    await HomeWidget.setAppGroupId(_appGroupId);
    unawaited(
      HomeWidget.registerInteractivityCallback(widgetBackgroundCallback),
    );
    _inited = true;
  }

  static Future<int> readCurrentForToday() async {
    if (!_inited) {
      await init();
    }
    final String today = todayDateKey();
    final String? storedDay = await HomeWidget.getWidgetData<String>(
      'current_day',
    );
    if (storedDay != today) {
      return 0;
    }
    return await HomeWidget.getWidgetData<int>('current_ml') ?? 0;
  }

  static Future<void> update({required int current, required int goal}) async {
    if (!_inited) {
      await init();
    }
    await HomeWidget.saveWidgetData<String>('current_day', todayDateKey());
    await HomeWidget.saveWidgetData<int>('current_ml', current);
    await HomeWidget.saveWidgetData<int>('goal_ml', goal);
    await HomeWidget.saveWidgetData<String>(
      'updated_at',
      DateTime.now().toIso8601String(),
    );
    await HomeWidget.updateWidget(
      name: _widgetName,
      iOSName: _iosWidgetName,
      qualifiedAndroidName:
          'com.mycompany.water_tracker.widget.WaterWidgetReceiver',
    );
  }

  static Future<int?> readCurrentTotal() async {
    return readCurrentForToday();
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(Uri? uri) async {
    try {
      if (uri == null) {
        return;
      }
      if (uri.host != 'add') {
        return;
      }
      final int ml = int.tryParse(uri.queryParameters['ml'] ?? '250') ?? 250;
      final bool syncOnly = uri.queryParameters['sync_only'] == '1';
      if (!kIsWeb) {
        WidgetsFlutterBinding.ensureInitialized();
      }

      if (!syncOnly) {
        final int previousCurrent = await readCurrentForToday();
        final int previousGoal =
            await HomeWidget.getWidgetData<int>('goal_ml') ?? 2000;
        final int total = previousCurrent + ml;
        await update(current: total, goal: previousGoal);
      }

      try {
        await SupabaseConfig.init();
        final User? user = Supabase.instance.client.auth.currentUser;
        if (user == null) {
          final OfflineQueue queue = await OfflineQueue.instance;
          await queue.enqueueAddIntake(ml);
          return;
        }
        final String uid = user.id;
        final DateTime now = DateTime.now();
        await Supabase.instance.client.from('water_intakes').insert(
          <String, dynamic>{
            'user_id': uid,
            'amount_ml': ml,
            'consumed_at': now.toIso8601String(),
            'created_at': now.toIso8601String(),
          },
        );
      } on Object {
        final OfflineQueue queue = await OfflineQueue.instance;
        await queue.enqueueAddIntake(ml);
      }
    } on Object catch (e) {
      debugPrint('Widget background callback failed: $e');
    }
  }
}
