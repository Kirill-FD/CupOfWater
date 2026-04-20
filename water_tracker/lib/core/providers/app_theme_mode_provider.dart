import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const String _kDarkEnabled = 'app_theme_dark';

  @override
  Future<ThemeMode> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kDarkEnabled) == true) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  Future<void> setDarkMode(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkEnabled, enabled);
    state = AsyncData<ThemeMode>(
      enabled ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
