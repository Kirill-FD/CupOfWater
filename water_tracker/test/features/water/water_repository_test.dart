import 'package:flutter_test/flutter_test.dart';
import 'package:gotrue/gotrue.dart' show User;
import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show GoTrueClient, SupabaseClient, SupabaseQueryBuilder;
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';
import '../../support/postgrest_future_fakes.dart';

class _MockClient extends Mock implements SupabaseClient {}

class _MockAuth extends Mock implements GoTrueClient {}

class _MockTable extends Mock implements SupabaseQueryBuilder {}

class _MockAfterInsert extends Mock
    implements PostgrestFilterBuilder<dynamic> {}

class _MockAfterSelect extends Mock
    implements PostgrestTransformBuilder<PostgrestList> {}

const User _kUser = User(
  id: '11111111-1111-1111-1111-111111111111',
  appMetadata: <String, dynamic>{},
  userMetadata: <String, dynamic>{},
  aud: 'authenticated',
  createdAt: '2020-01-01T00:00:00.000Z',
  email: 'a@a.com',
);

void main() {
  late _MockClient client;
  late _MockAuth auth;
  late _MockTable table;
  late WaterRepository repo;

  final Map<String, dynamic> serverRow = <String, dynamic>{
    'id': '22222222-2222-2222-2222-222222222222',
    'user_id': '11111111-1111-1111-1111-111111111111',
    'amount_ml': 250,
    'consumed_at': '2025-01-10T10:00:00.000Z',
    'created_at': '2025-01-10T10:00:00.000Z',
  };

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    client = _MockClient();
    auth = _MockAuth();
    table = _MockTable();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(_kUser);
    repo = WaterRepository(client);
  });

  test(
    'addIntake passes user_id, amount and consumed_at/created_at into insert',
    () async {
      final _MockAfterInsert afterInsert = _MockAfterInsert();
      final _MockAfterSelect afterSelect = _MockAfterSelect();
      when(() => client.from('water_intakes')).thenAnswer((_) => table);
      when(
        () => table.insert(
          any<Object>(),
          defaultToNull: any(named: 'defaultToNull'),
        ),
      ).thenAnswer((_) => afterInsert);
      when(() => afterInsert.select()).thenAnswer((_) => afterSelect);
      when(
        () => afterSelect.single(),
      ).thenAnswer((_) => AwaitablePostgrestMap(serverRow));

      final WaterIntake w = await repo.addIntake(250);
      final VerificationResult r = verify(
        () => table.insert(
          captureAny<Object>(),
          defaultToNull: any(named: 'defaultToNull'),
        ),
      );
      expect(r.callCount, 1);
      final Object cap = r.captured.single as Object;
      final Map<dynamic, dynamic> m = cap as Map<dynamic, dynamic>;

      expect(m['user_id'], _kUser.id);
      expect(m['amount_ml'], 250);
      expect(m, contains('consumed_at'));
      expect(m, contains('created_at'));
      expect(m['consumed_at'] as String, m['created_at'] as String);
      expect(w.id, serverRow['id']);
      expect(w.amountMl, 250);
    },
  );

  test('getTodayTotal awaits rpc and parses int', () async {
    when(
      () => client.rpc<dynamic>(
        'get_today_intake',
        params: <String, dynamic>{'p_user_id': _kUser.id},
      ),
    ).thenAnswer((_) => AwaitableDynamic(1850));

    expect(await repo.getTodayTotal(), 1850);
    verify(
      () => client.rpc<dynamic>(
        'get_today_intake',
        params: <String, dynamic>{'p_user_id': _kUser.id},
      ),
    ).called(1);
  });

  test('getStatsRange passes timezone and user id into rpc', () async {
    when(
      () => client.rpc<dynamic>(
        'get_stats_range',
        params: <String, dynamic>{
          'p_start': '2025-01-04',
          'p_end': '2025-01-10',
          'p_tz': 'Europe/Moscow',
          'p_user_id': _kUser.id,
        },
      ),
    ).thenAnswer(
      (_) => AwaitableDynamic(<Map<String, Object>>[
        <String, Object>{'day': '2025-01-04', 'total_ml': 1200},
        <String, Object>{'day': '2025-01-05', 'total_ml': 0},
      ]),
    );

    final Map<DateTime, int> stats = await repo.getStatsRange(
      DateTime(2025, 1, 4),
      DateTime(2025, 1, 10),
      timezone: 'Europe/Moscow',
    );

    expect(stats[DateTime(2025, 1, 4)], 1200);
    expect(stats[DateTime(2025, 1, 5)], 0);
    verify(
      () => client.rpc<dynamic>(
        'get_stats_range',
        params: <String, dynamic>{
          'p_start': '2025-01-04',
          'p_end': '2025-01-10',
          'p_tz': 'Europe/Moscow',
          'p_user_id': _kUser.id,
        },
      ),
    ).called(1);
  });

  test('deleteIntake issues delete and eq for id', () async {
    final _MockAfterInsert afterDelete = _MockAfterInsert();
    when(() => client.from('water_intakes')).thenAnswer((_) => table);
    when(() => table.delete()).thenAnswer((_) => afterDelete);
    when(
      () => afterDelete.eq('id', 'id-1'),
    ).thenAnswer((_) => AwaitableDeleteDone());
    when(() => auth.currentUser).thenReturn(_kUser);
    await repo.deleteIntake('id-1');
    verify(() => afterDelete.eq('id', 'id-1')).called(1);
  });
}
