import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as ftz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Синглтон: локальные уведомления, timezone, плановые напоминания.
class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  static const String _kNotifRequestOnceKey = 'notif_perms_asked_once';
  static const int _kImmediateId = 9999;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _inited = false;

  Future<void> init() async {
    if (_inited) {
      return;
    }
    tz_data.initializeTimeZones();
    final String? localTz = await ftz.FlutterTimezone.getLocalTimezone();
    if (localTz == null || localTz.isEmpty) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    } else {
      try {
        tz.setLocalLocation(tz.getLocation(localTz));
      } on Object {
        try {
          tz.setLocalLocation(tz.getLocation('UTC'));
        } on Object {
          // ignore: leave default
        }
      }
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      const AndroidNotificationChannel ch = AndroidNotificationChannel(
        'water_reminders',
        'Напоминания о воде',
        description: 'Регулярные напоминания пить воду',
        importance: Importance.high,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(ch);
    }
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: ios,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    _inited = true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('notification tap: id=${response.id} payload=${response.payload}');
    }
  }

  /// Запрашивает iOS (alert, badge, sound) и уведомления на Android 13+.
  Future<bool> requestPermissions() async {
    if (!_inited) {
      await init();
    }
    final bool? iosResult = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final bool? androidResult = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return (iosResult ?? true) && (androidResult ?? true);
  }

  /// Один раз (по флагу SharedPreferences) запрашивает разрешения: после первого
  /// [Home] или [Register] с сессией.
  Future<void> requestPermissionsIfFirstTime() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    if (p.getBool(_kNotifRequestOnceKey) == true) {
      return;
    }
    if (!_inited) {
      await init();
    }
    try {
      await requestPermissions();
    } on Object {
      // и даём поставить флаг, чтобы не дёргать повторно на каждом home
    }
    await p.setBool(_kNotifRequestOnceKey, true);
  }

  Future<void> cancelAllReminders() async {
    if (!_inited) {
      await init();
    }
    await _plugin.cancelAll();
  }

  static const NotificationDetails _kScheduleDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'water_reminders',
      'Напоминания о воде',
      channelDescription: 'Регулярные напоминания пить воду',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  Future<void> scheduleReminders({
    required bool enabled,
    required int intervalMinutes,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    if (!_inited) {
      await init();
    }
    await cancelAllReminders();
    if (!enabled) {
      return;
    }
    if (intervalMinutes <= 0) {
      return;
    }
    int startM = startTime.hour * 60 + startTime.minute;
    final int endM = endTime.hour * 60 + endTime.minute;
    if (endM < startM) {
      return;
    }
    final List<TimeOfDay> times = <TimeOfDay>[];
    while (startM <= endM) {
      times.add(TimeOfDay(hour: startM ~/ 60, minute: startM % 60));
      startM += intervalMinutes;
    }
    for (int i = 0; i < times.length; i++) {
      await _scheduleDaily(
        id: i,
        time: times[i],
        details: _kScheduleDetails,
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required TimeOfDay time,
    required NotificationDetails details,
  }) async {
    final math.Random random = math.Random();
    final List<String> titles = <String>[
      'Время пить воду 💧',
      'Не забудь про воду!',
      'Пора сделать глоток 💦',
    ];
    final List<String> bodies = <String>[
      'Поддержи норму гидратации',
      'Стакан воды — и ты молодец',
      'Твоё тело скажет спасибо',
    ];
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id,
      titles[random.nextInt(titles.length)],
      bodies[random.nextInt(bodies.length)],
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showImmediate(String title, String body) async {
    if (!_inited) {
      await init();
    }
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'water_reminders',
        'Напоминания о воде',
        channelDescription: 'Регулярные напоминания пить воду',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(_kImmediateId, title, body, details);
  }
}
