import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';

part 'user_weight_provider.g.dart';

@Riverpod(keepAlive: true)
class UserWeightKg extends _$UserWeightKg {
  static String _prefsKey(String userId) => 'profile_weight_kg_$userId';

  @override
  Future<double?> build() async {
    ref.watch(currentUserProvider);
    final User? u = ref.read(currentUserProvider);
    if (u == null) {
      return null;
    }
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getDouble(_prefsKey(u.id));
  }

  Future<void> setKg(double kg) async {
    final User? u = ref.read(currentUserProvider);
    if (u == null) {
      return;
    }
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setDouble(_prefsKey(u.id), kg);
    state = AsyncData<double?>(kg);
  }
}
