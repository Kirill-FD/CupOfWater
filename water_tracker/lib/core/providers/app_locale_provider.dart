// Язык интерфейса: en / ru + SharedPreferences.

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_locale_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static const String _kLocaleCode = 'app_locale_code';

  @override
  Future<Locale> build() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? code = p.getString(_kLocaleCode);
    if (code == 'ru') {
      return const Locale('ru');
    }
    if (code == 'en') {
      return const Locale('en');
    }
    final String sys =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    if (sys == 'ru') {
      return const Locale('ru');
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final String code = locale.languageCode;
    if (code != 'en' && code != 'ru') {
      return;
    }
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString(_kLocaleCode, code);
    state = AsyncData<Locale>(Locale(code));
  }
}
