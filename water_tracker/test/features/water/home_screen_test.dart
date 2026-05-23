import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/core/providers/widget_sync_provider.dart';
import 'package:water_tracker/features/auth/domain/models/user_profile.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/settings/data/settings_repository.dart';
import 'package:water_tracker/features/settings/presentation/providers/settings_provider.dart';
import 'package:water_tracker/features/stats/presentation/providers/stats_provider.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/features/water/presentation/screens/home_screen.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:gotrue/gotrue.dart' show User;

class _MockRepo extends Mock implements WaterRepository {}

class _MockSettingsRepo extends Mock implements SettingsRepository {}

const User _kUser = User(
  id: '11111111-1111-1111-1111-111111111111',
  appMetadata: <String, dynamic>{},
  userMetadata: <String, dynamic>{},
  aud: 'authenticated',
  createdAt: '2020-01-01T00:00:00.000Z',
  email: 'a@a.com',
);

void main() {
  late _MockRepo mockRepo;
  late _MockSettingsRepo mockSettings;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepo = _MockRepo();
    mockSettings = _MockSettingsRepo();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    when(() => mockRepo.getTodayIntakes()).thenAnswer((_) async => <WaterIntake>[]);
    when(() => mockSettings.getProfile()).thenAnswer(
      (_) async => UserProfile(id: _kUser.id, dailyGoalMl: 2000),
    );
    when(() => mockRepo.addIntake(any<int>())).thenAnswer((invocation) async {
      final int ml = invocation.positionalArguments[0] as int;
      final DateTime t = DateTime(2020, 1, 1);
      return WaterIntake(
        id: 'real-1',
        userId: _kUser.id,
        amountMl: ml,
        consumedAt: t,
        createdAt: t,
      );
    });
  });

  testWidgets('home shows progress circle, CTA, ListView; tap +250ml calls addIntake(250)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          waterRepositoryProvider.overrideWithValue(mockRepo),
          settingsRepositoryProvider.overrideWithValue(mockSettings),
          isOnlineNowProvider.overrideWith((_) async => true),
          dailyWaterGoalProvider.overrideWith((_) async => 2000),
          weeklyStatsProvider.overrideWith((_) async {
            final Map<DateTime, int> m = <DateTime, int>{};
            for (int i = 0; i < 7; i++) {
              m[DateTime(2020, 1, 1 + i)] = 0;
            }
            return m;
          }),
          currentStreakProvider.overrideWith((_) async => 0),
          currentUserProvider.overrideWithValue(_kUser),
          widgetSyncProvider.overrideWithValue(0),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byType(WaterProgressCircle), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
    expect(find.byType(ListView), findsWidgets);
    await tester.tap(
      find.ancestor(
        of: find.byType(WaterProgressCircle),
        matching: find.byType(GestureDetector),
      ).first,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    verify(() => mockRepo.addIntake(250)).called(1);
  });
}
