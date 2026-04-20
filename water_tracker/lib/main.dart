import 'dart:async' show unawaited;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/app_bootstrap.dart';
import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/core/providers/theme_provider.dart';
import 'package:water_tracker/core/router/app_router.dart';
import 'package:water_tracker/core/theme/app_theme.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/offline_queue.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

Future<void> main() async {
  await bootstrapApp();
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

    // Очередь offline: при смене сети на online — сброс в Supabase
    ref.listen<AsyncValue<List<ConnectivityResult>>>(
      connectivityStreamProvider,
      (AsyncValue<List<ConnectivityResult>>? a, AsyncValue<List<ConnectivityResult>> b) {
        b.whenData((List<ConnectivityResult> r) {
          if (!isOnlineList(r)) {
            return;
          }
          if (Supabase.instance.client.auth.currentUser == null) {
            return;
          }
          unawaited(_flushQueue(ref));
        });
      },
      fireImmediately: true,
    );

    return ref.watch(themeProvider).when(
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

Future<void> _flushQueue(WidgetRef ref) async {
  final OfflineQueue q = await OfflineQueue.instance;
  final int n = await q.flush(Supabase.instance.client);
  if (n > 0) {
    ref.invalidate(todayIntakesProvider);
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
      onGenerateTitle: (BuildContext c) => AppLocalizations.of(c).appTitle,
      routerConfig: router,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
