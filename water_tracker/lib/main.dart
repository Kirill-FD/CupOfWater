import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import 'package:water_tracker/core/config/supabase_config.dart';
import 'package:water_tracker/core/providers/app_theme_mode_provider.dart';
import 'package:water_tracker/core/router/app_router.dart';
import 'package:water_tracker/core/theme/app_theme.dart';
import 'package:water_tracker/shared/services/notification_service.dart';
import 'package:water_tracker/shared/services/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);
    return ref.watch(appThemeModeProvider).when(
          data: (ThemeMode m) {
            return _MaterialApp(router, m);
          },
          loading: () {
            return _MaterialApp(router, ThemeMode.system);
          },
          error: (Object? _, Object? __) {
            return _MaterialApp(router, ThemeMode.system);
          },
        );
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp(
    this.router,
    this.themeMode,
  );

  final GoRouter router;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Water Tracker',
      routerConfig: router,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
