import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:water_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:water_tracker/features/auth/presentation/screens/splash_screen.dart';
import 'package:water_tracker/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:water_tracker/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:water_tracker/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:water_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:water_tracker/features/stats/presentation/screens/stats_screen.dart';
import 'package:water_tracker/features/water/presentation/screens/home_screen.dart';
import 'package:water_tracker/l10n/app_localizations.dart';

part 'app_router.g.dart';

class _MainShell extends ConsumerWidget {
  const _MainShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (int i) {
          navigationShell.goBranch(i);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart),
            label: l.navStats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
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
  ref.listen<AsyncValue<bool>>(
    onboardingProvider,
    (AsyncValue<bool>? _, AsyncValue<bool> __) {
      refresh.value++;
    },
    fireImmediately: true,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) {
      // Widget deep links shouldn't be treated as app routes.
      if (state.uri.scheme == 'waterwidget') {
        return '/home';
      }
      final Session? session = Supabase.instance.client.auth.currentSession;
      final String location = state.matchedLocation;

      final bool onAuthPages =
          location == '/login' || location == '/register';
      final bool onOnboarding = location == '/onboarding';

      if (session == null) {
        if (onAuthPages) {
          return null;
        }
        return '/login';
      }

      final AsyncValue<bool> onboarding = ref.read(onboardingProvider);

      return onboarding.maybeWhen(
        data: (bool completed) {
          if (!completed) {
            if (onOnboarding) {
              return null;
            }
            return '/onboarding';
          }
          if (onOnboarding) {
            return '/home';
          }
          if (onAuthPages) {
            return '/home';
          }
          if (location == '/splash') {
            return '/home';
          }
          return null;
        },
        orElse: () {
          if (location != '/splash') {
            return '/splash';
          }
          return null;
        },
      );
    },
    errorBuilder: (BuildContext context, GoRouterState state) {
      return const SplashScreen();
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
        path: '/onboarding',
        name: 'onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return _MainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/stats',
                name: 'stats',
                builder: (BuildContext context, GoRouterState state) {
                  return const StatsScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (BuildContext context, GoRouterState state) {
                  return const SettingsScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'privacy',
                    name: 'privacy-policy',
                    builder: (BuildContext context, GoRouterState state) {
                      return const PrivacyPolicyScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
