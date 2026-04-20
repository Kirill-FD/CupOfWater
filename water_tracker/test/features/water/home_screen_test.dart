import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/core/providers/widget_sync_provider.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';
import 'package:water_tracker/features/water/presentation/screens/home_screen.dart';
import 'package:water_tracker/features/water/presentation/widgets/water_progress_circle.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:gotrue/gotrue.dart' show User;

class _MockRepo extends Mock implements WaterRepository {}

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

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepo = _MockRepo();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    when(() => mockRepo.getTodayIntakes()).thenAnswer((_) async => <WaterIntake>[]);
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
          isOnlineNowProvider.overrideWith((_) async => true),
          dailyWaterGoalProvider.overrideWith((_) async => 2000),
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
    await tester.pumpAndSettle();
    expect(find.byType(WaterProgressCircle), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
    verify(() => mockRepo.addIntake(250)).called(1);
  });
}
