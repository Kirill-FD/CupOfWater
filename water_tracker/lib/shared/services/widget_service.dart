import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:home_widget/home_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show
    Supabase,
    User;

import 'package:water_tracker/core/config/supabase_config.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';

class WidgetService {
  WidgetService._();
  static const String _widgetName = 'WaterWidget';
  static const String _iosWidgetName = 'WaterWidget';
  static const String _appGroupId = 'group.com.mycompany.watertracker';

  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) {
      return;
    }
    await HomeWidget.setAppGroupId(_appGroupId);
    unawaited(
      HomeWidget.registerInteractivityCallback(backgroundCallback),
    );
    _inited = true;
  }

  static Future<void> update({required int current, required int goal}) async {
    if (!_inited) {
      await init();
    }
    await HomeWidget.saveWidgetData<int>('current_ml', current);
    await HomeWidget.saveWidgetData<int>('goal_ml', goal);
    await HomeWidget.saveWidgetData<String>(
      'updated_at',
      DateTime.now().toIso8601String(),
    );
    await HomeWidget.updateWidget(
      name: _widgetName,
      iOSName: _iosWidgetName,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(Uri? uri) async {
    if (uri == null) {
      return;
    }
    if (uri.host != 'add') {
      return;
    }
    final int ml = int.tryParse(uri.queryParameters['ml'] ?? '250') ?? 250;
    if (!kIsWeb) {
      WidgetsFlutterBinding.ensureInitialized();
    }
    await SupabaseConfig.init();
    final User? user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
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
    final int total =
        await WaterRepository(Supabase.instance.client).getTodayTotal();
    final Object? r = await Supabase.instance.client
        .from('profiles')
        .select('daily_goal_ml')
        .eq('id', uid)
        .single();
    final int goal;
    if (r is Map) {
      final Map<dynamic, dynamic> m = r;
      goal = (m['daily_goal_ml'] as num?)?.toInt() ?? 2000;
    } else {
      goal = 2000;
    }
    await update(current: total, goal: goal);
  }
}
