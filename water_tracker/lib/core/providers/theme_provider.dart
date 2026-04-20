// Псевдоним [themeProvider] = [appThemeModeProvider] (см. ТЗ).

import 'app_theme_mode_provider.dart';

export 'app_theme_mode_provider.dart' show AppThemeMode, appThemeModeProvider;

// ignore: non_constant_identifier_names
// ignore: type_annotate_public_apis, public_member_api_docs
final themeProvider = appThemeModeProvider;
