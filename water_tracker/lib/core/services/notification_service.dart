import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as ftz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';

/// Планировщик локальных напоминаний. Вызывать [init] из [main] после [WidgetsFlutterBinding].
class NotificationService {
  NotificationService._();

  static const int _kBaseId = 10000;
  static const int _kMaxScheduled = 32;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'reminders',
    'Напоминания',
    description: 'Напоминания о воде',
    importance: Importance.defaultImportance,
  );

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Напоминания',
      channelDescription: 'Напоминания о воде',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) {
      return;
    }
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings darwin = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: darwin,
    );
    await _plugin.initialize(
      settings,
    );
    await _configureLocalTimeZone();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? android =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(_androidChannel);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      final AndroidFlutterLocalNotificationsPlugin? android = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    }
    _inited = true;
  }

  static Future<void> _configureLocalTimeZone() async {
    try {
      tz_data.initializeTimeZones();
      final String? name = await ftz.FlutterTimezone.getLocalTimezone();
      if (name != null && name.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(name));
      } else {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
    } on Object {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  static Future<void> scheduleReminders(UserProfile profile) async {
    if (!_inited) {
      await init();
    }
    await _plugin.cancelAll();
    if (!profile.reminderEnabled) {
      return;
    }
    if (profile.reminderIntervalMinutes <= 0) {
      return;
    }
    final TimeOfDay startTod = profile.startTimeOfDay;
    final TimeOfDay endTod = profile.endTimeOfDay;
    final int startM = startTod.hour * 60 + startTod.minute;
    final int endM = endTod.hour * 60 + endTod.minute;
    if (endM <= startM) {
      return;
    }
    final int interval = profile.reminderIntervalMinutes;
    int slot = 0;
    final DateTime now = DateTime.now();

    for (int day = 0; day < 14 && slot < _kMaxScheduled; day++) {
      final DateTime base = DateTime(now.year, now.month, now.day);
      final DateTime withDay = base.add(Duration(days: day));
      var t = DateTime(
        withDay.year,
        withDay.month,
        withDay.day,
        startTod.hour,
        startTod.minute,
      );
      final DateTime endOfDay = DateTime(
        withDay.year,
        withDay.month,
        withDay.day,
        endTod.hour,
        endTod.minute,
      );
      while (slot < _kMaxScheduled && !t.isAfter(endOfDay)) {
        if (t.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
          t = t.add(Duration(minutes: interval));
          continue;
        }
        final tz.TZDateTime when = tz.TZDateTime.from(t, tz.local);
        await _plugin.zonedSchedule(
          _kBaseId + slot,
          'Пора пить воду',
          'Добавьте запись в трекер',
          when,
          _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'reminder',
        );
        slot++;
        t = t.add(Duration(minutes: interval));
      }
    }
  }

  static Future<void> showImmediate() async {
    if (!_inited) {
      await init();
    }
    const int kTestId = 2;
    await _plugin.show(
      kTestId,
      'Тест',
      'Уведомления настроены',
      _details,
    );
  }
}
