import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue('');
  });

  setUp(() {
    mockRepo = _MockRepo();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('optimistic addIntake: keeps row when server write is queued offline', () async {
    when(() => mockRepo.getTodayIntakes()).thenAnswer((_) async => <WaterIntake>[]);
    when(() => mockRepo.addIntakeFast(200)).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 80));
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
    final ProviderSubscription<AsyncValue<List<WaterIntake>>> sub = c.listen(
      todayIntakesProvider,
      (AsyncValue<List<WaterIntake>>? _, AsyncValue<List<WaterIntake>> __) {},
    );
    addTearDown(sub.close);
    await c.read(todayIntakesProvider.future);
    final Future<AddIntakeResult> f =
        c.read(todayIntakesProvider.notifier).addIntake(200);
    List<WaterIntake>? mid;
    for (int i = 0; i < 40; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      mid = c.read(todayIntakesProvider).valueOrNull;
      if (mid?.any((WaterIntake w) => w.id.startsWith('temp-')) ?? false) {
        break;
      }
    }
    expect(mid?.any((WaterIntake i) => i.id.startsWith('temp-')), isTrue);
    final AddIntakeResult result = await f;
    expect(result.queuedOffline, isTrue);
    final List<WaterIntake>? end = c.read(todayIntakesProvider).valueOrNull;
    expect(
      end?.any((WaterIntake i) => i.id.startsWith('temp-')),
      isTrue,
    );
  });
}
