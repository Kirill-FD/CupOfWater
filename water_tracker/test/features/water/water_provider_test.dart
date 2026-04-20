import 'package:flutter_test/flutter_test.dart';
import 'package:gotrue/gotrue.dart' show User;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_tracker/core/providers/connectivity_state_provider.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import 'package:water_tracker/features/water/presentation/providers/water_provider.dart';

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
    registerFallbackValue('');
  });

  setUp(() {
    mockRepo = _MockRepo();
  });

  test('optimistic addIntake: temp row then rollback on error', () async {
    when(() => mockRepo.getTodayIntakes()).thenAnswer((_) async => <WaterIntake>[]);
    when(() => mockRepo.addIntake(200)).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      throw Exception('network');
    });
    when(() => mockRepo.deleteIntake(any<String>())).thenAnswer((_) async {});

    final ProviderContainer c = ProviderContainer(
      overrides: <Override>[
        waterRepositoryProvider.overrideWithValue(mockRepo),
        isOnlineNowProvider.overrideWith((_) async => true),
        dailyWaterGoalProvider.overrideWith((_) async => 2000),
        currentUserProvider.overrideWithValue(_kUser),
      ],
    );
    addTearDown(c.dispose);
    await c.read(todayIntakesProvider.future);
    final Future<AddIntakeResult> f = c.read(todayIntakesProvider.notifier).addIntake(200);
    await Future<void>.delayed(const Duration(milliseconds: 2));
    final List<WaterIntake>? mid = c.read(todayIntakesProvider).valueOrNull;
    expect(mid?.any((WaterIntake i) => i.id.startsWith('temp-')), isTrue);
    try {
      await f;
    } on Exception {
      // expected
    }
    final List<WaterIntake>? end = c.read(todayIntakesProvider).valueOrNull;
    expect(
      end?.any((WaterIntake i) => i.id.startsWith('temp-')),
      isFalse,
    );
  });
}
