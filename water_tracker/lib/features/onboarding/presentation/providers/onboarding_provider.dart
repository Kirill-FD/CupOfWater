import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';

part 'onboarding_provider.g.dart';

/// Ключ по пользователю (глобальный флаг ломал мультиаккаунт).
String _onboardingKey(String userId) => 'onboarding_completed_$userId';

/// Старый общий ключ (до привязки к user id).
const String _kLegacyOnboardingGlobal = 'onboarding_completed';

/// Локальный флаг onboarding на аккаунт (Supabase user id).
@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  @override
  Future<bool> build() async {
    final User? user =
        ref.watch(currentUserProvider) ?? Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return true;
    }
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String key = _onboardingKey(user.id);
    final bool? byUser = p.getBool(key);
    if (byUser != null) {
      return byUser;
    }
    final bool? legacy = p.getBool(_kLegacyOnboardingGlobal);
    if (legacy != null) {
      await p.setBool(key, legacy);
      return legacy;
    }
    // Уже зарегистрированный ранее пользователь не должен снова видеть onboarding.
    return true;
  }

  Future<void> setPendingForNewUser() async {
    final User? user =
        ref.read(currentUserProvider) ?? Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }
    await setPendingForUserId(user.id);
  }

  Future<void> setPendingForUserId(String userId) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_onboardingKey(userId), false);
    state = const AsyncData<bool>(false);
  }

  Future<void> markCompleted() async {
    final User? user =
        ref.read(currentUserProvider) ?? Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_onboardingKey(user.id), true);
    state = const AsyncData<bool>(true);
  }
}
