import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:water_tracker/core/config/supabase_config.dart';
import 'package:water_tracker/core/error/app_error_handler.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

/// One-time app initialization (Supabase, notifications, home widget).
/// Used from [main] and from integration / driver tests.
Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  installAppErrorHandlers();
  await SupabaseConfig.init();
  await NotificationService.instance.init();
  await WidgetService.init();
  final Uri? launchFromWidget = await HomeWidget.initiallyLaunchedFromHomeWidget();
  if (launchFromWidget != null) {
    await WidgetService.backgroundCallback(launchFromWidget);
  }
  HomeWidget.widgetClicked.listen((Uri? uri) {
    if (uri == null) {
      return;
    }
    unawaited(WidgetService.backgroundCallback(uri));
  });
}
