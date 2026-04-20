import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/data/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(Supabase.instance.client);
}

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  final AsyncValue<AuthState> authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (AuthState state) => state.session?.user,
    orElse: () => ref.read(authRepositoryProvider).currentUser,
  );
}
