import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:water_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:water_tracker/features/auth/presentation/screens/splash_screen.dart';
import 'package:water_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:water_tracker/features/stats/presentation/screens/stats_screen.dart';
import 'package:water_tracker/features/water/presentation/screens/home_screen.dart';

part 'app_router.g.dart';

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  ref.listen<AsyncValue<AuthState>>(
    authStateProvider,
    (AsyncValue<AuthState>? previous, AsyncValue<AuthState> next) {
      refresh.value++;
    },
    fireImmediately: true,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) {
      final Session? session = Supabase.instance.client.auth.currentSession;
      final String location = state.matchedLocation;

      final bool onAuthPages =
          location == '/login' || location == '/register';

      if (session == null) {
        if (onAuthPages) {
          return null;
        }
        return '/login';
      }

      if (onAuthPages) {
        return '/home';
      }

      if (location == '/splash') {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (BuildContext context, GoRouterState state) {
          return const StatsScreen();
        },
      ),
    ],
  );
}
