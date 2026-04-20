import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/domain/errors/auth_repository_exception.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw mapGotrueAuthException(e);
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw mapGotrueAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw mapGotrueAuthException(e);
    }
  }
}
