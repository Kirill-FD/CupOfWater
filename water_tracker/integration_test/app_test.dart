import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
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
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:gotrue/gotrue.dart' show User;

class _ItRepo extends Mock implements WaterRepository {}

const User _kItUser = User(
  id: '11111111-1111-1111-1111-111111111111',
  appMetadata: <String, dynamic>{},
  userMetadata: <String, dynamic>{},
  aud: 'authenticated',
  createdAt: '2020-01-01T00:00:00.000Z',
  email: 'e2e@test.com',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(0);
    registerFallbackValue('');
  });

  testWidgets('in-memory: add glass (250ml) then swipe delete (post-auth home)', (WidgetTester t) async {
    final _ItRepo repo = _ItRepo();
    final List<WaterIntake> store = <WaterIntake>[];
    when(() => repo.getTodayIntakes()).thenAnswer((_) async => List<WaterIntake>.from(store));
    when(() => repo.addIntake(any<int>())).thenAnswer((invocation) async {
      final int ml = invocation.positionalArguments[0] as int;
      final DateTime n = DateTime(2020, 5, 5, 12);
      final WaterIntake w = WaterIntake(
        id: 'it-id',
        userId: _kItUser.id,
        amountMl: ml,
        consumedAt: n,
        createdAt: n,
      );
      store
        ..clear()
        ..add(w);
      return w;
    });
    when(() => repo.deleteIntake(any<String>())).thenAnswer((invocation) async {
      final String id = invocation.positionalArguments[0] as String;
      store.removeWhere((WaterIntake e) => e.id == id);
    });
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await t.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          waterRepositoryProvider.overrideWithValue(repo),
          isOnlineNowProvider.overrideWith((_) async => true),
          dailyWaterGoalProvider.overrideWith((_) async => 2000),
          currentUserProvider.overrideWithValue(_kItUser),
          widgetSyncProvider.overrideWithValue(0),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.textContaining('250'), findsWidgets);
    await t.tap(find.byType(ElevatedButton).first);
    await t.pumpAndSettle();
    final Finder row = find.text('250 ml');
    expect(row, findsOneWidget);
    final Finder tile = find.ancestor(of: row, matching: find.byType(Dismissible));
    expect(tile, findsOneWidget);
    await t.fling(tile, const Offset(-400, 0), 1000);
    await t.pumpAndSettle();
    expect(find.text('250 ml'), findsNothing);
  });
}
