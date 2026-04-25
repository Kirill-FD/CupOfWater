import 'dart:async' show TimeoutException, unawaited;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/app_bootstrap.dart';
import 'package:water_tracker/core/error/app_error_handler.dart';
import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/core/providers/theme_provider.dart';
import 'package:water_tracker/core/router/app_router.dart';
import 'package:water_tracker/core/theme/app_theme.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/shared/services/offline_queue.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

/// Долгий «логотип Flutter» на экране бывает, если [bootstrapApp] ждёт сеть
/// (например Supabase при восстановлении сессии) до первого [runApp].
const Duration _kBootstrapTimeout = Duration(seconds: 90);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  installAppErrorHandlers();
  runApp(
    const ProviderScope(
      child: _AppLoader(),
    ),
  );
}

class _AppLoader extends StatefulWidget {
  const _AppLoader();

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      await bootstrapApp().timeout(
        _kBootstrapTimeout,
        onTimeout: () {
          throw TimeoutException(
            'Превышено время ожидания (90 с). Проверьте интернет на эмуляторе '
            'и при необходимости укажите --dart-define=SUPABASE_URL / '
            'SUPABASE_ANON_KEY. '
            'Первый запуск Supabase к проекту без сети может зависать.',
          );
        },
      );
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _error = e is TimeoutException ? e.message : e.toString();
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (!_ready) {
      return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 20),
                Text('Загрузка…'),
              ],
            ),
          ),
        ),
      );
    }
    return const MyApp();
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Очередь offline: при смене сети на online — сброс в Supabase
    ref.listenManual<AsyncValue<List<ConnectivityResult>>>(
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
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(appRouterProvider);

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
