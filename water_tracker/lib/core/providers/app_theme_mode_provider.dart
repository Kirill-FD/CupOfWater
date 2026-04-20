// Режим темы: system / light / dark + shared_preferences.

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const String _kMode = 'app_theme_mode_v2';
  static const String _kLegacyDark = 'app_theme_dark';

  @override
  Future<ThemeMode> build() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await _migrate(p);
    final String? s = p.getString(_kMode);
    if (s == 'light') {
      return ThemeMode.light;
    }
    if (s == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  Future<void> _migrate(SharedPreferences p) async {
    if (p.containsKey(_kMode)) {
      return;
    }
    final bool? old = p.getBool(_kLegacyDark);
    if (old == null) {
      return;
    }
    await p.setString(_kMode, old ? 'dark' : 'light');
  }

  /// system | light | dark
  Future<void> setTheme(ThemeMode mode) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString(_kMode, mode.name);
    state = AsyncData<ThemeMode>(mode);
  }
}
