import 'package:flutter_test/flutter_test.dart';
import 'package:gotrue/gotrue.dart' show User;
import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart' show PostgrestMap;
import 'package:supabase_flutter/supabase_flutter.dart' show
    GoTrueClient,
    PostgrestFilterBuilder,
    SupabaseClient,
    SupabaseQueryBuilder;
import 'package:water_tracker/features/water/data/water_repository.dart';
import 'package:water_tracker/features/water/domain/models/water_intake.dart';

class _MockClient extends Mock implements SupabaseClient {}

class _MockAuth extends Mock implements GoTrueClient {}

class _MockTable extends Mock implements SupabaseQueryBuilder {}

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
  final Map<String, dynamic> _serverRow = <String, dynamic>{
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

  test('addIntake passes user_id, amount and consumed_at/created_at into insert', () async {
    final _MockTable afterInsert = _MockTable();
    final _MockTable afterSelect = _MockTable();
    when(() => client.from('water_intakes')).thenReturn(table);
    when(
      () => table.insert(
        any<Object>(),
        defaultToNull: any(named: 'defaultToNull'),
      ),
    ).thenReturn(afterInsert);
    when(() => afterInsert.select()).thenReturn(afterSelect);
    // PostgREST builders implement Future; await the last step.
    when(() => afterSelect.single())
        .thenReturn(Future<PostgrestMap>.value(_serverRow) as PostgrestFilterBuilder<dynamic>);

    final WaterIntake w = await repo.addIntake(250);
    final VerificationResult r = verify(
      () => table.insert(
        captureAny<dynamic>(),
        defaultToNull: any(named: 'defaultToNull'),
      ),
    )..called(1);
    final Object cap = r.captured.single;
    final Map<dynamic, dynamic> m = cap as Map<dynamic, dynamic>;

    expect(m['user_id'], _kUser.id);
    expect(m['amount_ml'], 250);
    expect(m, contains('consumed_at'));
    expect(m, contains('created_at'));
    expect(m['consumed_at'] as String, m['created_at'] as String);
    expect(w.id, _serverRow['id']);
    expect(w.amountMl, 250);
  });

  test('getTodayTotal awaits rpc and parses int', () async {
    when(
      () => client.rpc<dynamic>(
        'get_today_intake',
        params: <String, dynamic>{'p_user_id': _kUser.id},
      ),
    ).thenReturn(Future<dynamic>.value(1850) as PostgrestFilterBuilder<dynamic>);

    expect(await repo.getTodayTotal(), 1850);
    verify(
      () => client.rpc<dynamic>(
        'get_today_intake',
        params: <String, dynamic>{'p_user_id': _kUser.id},
      ),
    )..called(1);
  });

  test('deleteIntake issues delete and eq for id', () async {
    final _MockTable afterDelete = _MockTable();
    when(() => client.from('water_intakes')).thenReturn(table);
    when(() => table.delete()).thenReturn(afterDelete);
    when(() => afterDelete.eq('id', 'id-1')).thenReturn(
      Future<dynamic>.value(null) as PostgrestFilterBuilder<dynamic>,
    );
    when(() => auth.currentUser).thenReturn(_kUser);
    await repo.deleteIntake('id-1');
    verify(
      () => afterDelete.eq('id', 'id-1'),
    )..called(1);
  });
}
