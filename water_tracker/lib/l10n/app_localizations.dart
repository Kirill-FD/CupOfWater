// Ручная реализация в стиле flutter gen-l10n. После `flutter gen-l10n` можно
// сравнить с сгенерированным деревом, если нужна автосинхронизация с ARB.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';

/// Локализации приложения (en / ru).
class AppLocalizations {
  const AppLocalizations._(this._d);

  final _LocData _d;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? t =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (t == null) {
      throw StateError('AppLocalizations not found in context');
    }
    return t;
  }

  // Все публичные геттеры/методы
  String get appName => _d.appName;
  String get appTitle => _d.appTitle;
  String get homeTitle => _d.homeTitle;
  String get addWater => _d.addWater;
  String addWaterWithMl(int ml) => _d.addWaterWithMl(ml);
  String get todayHistory => _d.todayHistory;
  String get goalTitle => _d.goalTitle;
  String get dailyGoal => _d.dailyGoal;
  String get reminders => _d.reminders;
  String get login => _d.login;
  String get register => _d.register;
  String get signUpCta => _d.signUpCta;
  String get registerAppBar => _d.registerAppBar;
  String get email => _d.email;
  String get password => _d.password;
  String get confirmPassword => _d.confirmPassword;
  String get logout => _d.logout;
  String get settings => _d.settings;
  String get stats => _d.stats;
  String get navHome => _d.navHome;
  String get navStats => _d.navStats;
  String get navSettings => _d.navSettings;
  String get weeklyStats => _d.weeklyStats;
  String get monthlyStats => _d.monthlyStats;
  String get streak => _d.streak;
  String get streakLabel => _d.streakLabel;
  String get statsTitle => _d.statsTitle;
  String get goalReached => _d.goalReached;
  String get addFirstIntake => _d.addFirstIntake;
  String goalLoadError(String message) => _d.goalLoadError(message);
  String get retry => _d.retry;
  String get mlUnit => _d.mlUnit;
  String get averagePerDay => _d.averagePerDay;
  String get daysGoalMet => _d.daysGoalMet;
  String get profile => _d.profile;
  String get name => _d.name;
  String get notSet => _d.notSet;
  String get nameHint => _d.nameHint;
  String get nameFieldLabel => _d.nameFieldLabel;
  String get reminderInterval => _d.reminderInterval;
  String get reminderFrom => _d.reminderFrom;
  String get reminderTo => _d.reminderTo;
  String get reminderTest => _d.reminderTest;
  String get reminderTestTitle => _d.reminderTestTitle;
  String get reminderTestBody => _d.reminderTestBody;
  String get appearance => _d.appearance;
  String get themeSystem => _d.themeSystem;
  String get themeLight => _d.themeLight;
  String get themeDark => _d.themeDark;
  String get account => _d.account;
  String get about => _d.about;
  String get version => _d.version;
  String get privacy => _d.privacy;
  String get privacyOpenFailed => _d.privacyOpenFailed;
  String get logoutTitle => _d.logoutTitle;
  String get save => _d.save;
  String get cancel => _d.cancel;
  String errorGeneric(String message) => _d.errorGeneric(message);
  String remindersError(String message) => _d.remindersError(message);
  String get minPassword => _d.minPassword;
  String get enterEmail => _d.enterEmail;
  String get invalidEmail => _d.invalidEmail;
  String get enterPassword => _d.enterPassword;
  String get noAccount => _d.noAccount;
  String get haveAccount => _d.haveAccount;
  String get checkEmailConfirm => _d.checkEmailConfirm;
  String get registerSuccess => _d.registerSuccess;
  String get enterPasswordConfirm => _d.enterPasswordConfirm;
  String get passwordsMismatch => _d.passwordsMismatch;
  String get weightKg => _d.weightKg;
  String get weightExample => _d.weightExample;
  String get calculateByWeight => _d.calculateByWeight;
  String minutesShort(int n) => _d.minutesShort(n);
  String get ok => _d.ok;
  String get profileLoadError => _d.profileLoadError;
  String get themeLoadError => _d.themeLoadError;
  String get remindersLabel => _d.remindersLabel;
  String mlFormat(int n) => _d.mlFormat(n);
  String get addWaterAction => _d.addWaterAction;
  String get noData => _d.noData;
  String get emptyCta => _d.emptyCta;
  String get logoutFailed => _d.logoutFailed;
}

// Доп. ключ, не в ARB (снабжен в обоих)
abstract class _LocData {
  String get appName;
  String get appTitle;
  String get homeTitle;
  String get addWater;
  String addWaterWithMl(int ml);
  String get todayHistory;
  String get goalTitle;
  String get dailyGoal;
  String get reminders;
  String get login;
  String get register;
  String get signUpCta;
  String get registerAppBar;
  String get email;
  String get password;
  String get confirmPassword;
  String get logout;
  String get settings;
  String get stats;
  String get navHome;
  String get navStats;
  String get navSettings;
  String get weeklyStats;
  String get monthlyStats;
  String get streak;
  String get streakLabel;
  String get statsTitle;
  String get goalReached;
  String get addFirstIntake;
  String goalLoadError(String message);
  String get retry;
  String get mlUnit;
  String get averagePerDay;
  String get daysGoalMet;
  String get profile;
  String get name;
  String get notSet;
  String get nameHint;
  String get nameFieldLabel;
  String get reminderInterval;
  String get reminderFrom;
  String get reminderTo;
  String get reminderTest;
  String get reminderTestTitle;
  String get reminderTestBody;
  String get appearance;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get account;
  String get about;
  String get version;
  String get privacy;
  String get privacyOpenFailed;
  String get logoutTitle;
  String get save;
  String get cancel;
  String errorGeneric(String message);
  String remindersError(String message);
  String get minPassword;
  String get enterEmail;
  String get invalidEmail;
  String get enterPassword;
  String get noAccount;
  String get haveAccount;
  String get checkEmailConfirm;
  String get registerSuccess;
  String get enterPasswordConfirm;
  String get passwordsMismatch;
  String get weightKg;
  String get weightExample;
  String get calculateByWeight;
  String minutesShort(int n);
  String get ok;
  String get profileLoadError;
  String get themeLoadError;
  String get remindersLabel;
  String mlFormat(int n);
  String get addWaterAction;
  String get noData;
  String get emptyCta;
  String get logoutFailed;
}

class _En extends _LocData {
  @override
  String get appName => 'Water tracker';
  @override
  String get appTitle => 'Water Tracker';
  @override
  String get homeTitle => 'Today';
  @override
  String get addWater => 'Add water';
  @override
  String addWaterWithMl(int ml) => '+$ml ml';
  @override
  String get todayHistory => 'Today';
  @override
  String get goalTitle => 'Goal';
  @override
  String get dailyGoal => 'Daily goal';
  @override
  String get reminders => 'Reminders';
  @override
  String get login => 'Log in';
  @override
  String get register => 'Create account';
  @override
  String get signUpCta => 'Sign up';
  @override
  String get registerAppBar => 'Register';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get confirmPassword => 'Confirm password';
  @override
  String get logout => 'Log out';
  @override
  String get settings => 'Settings';
  @override
  String get stats => 'Stats';
  @override
  String get navHome => 'Home';
  @override
  String get navStats => 'Stats';
  @override
  String get navSettings => 'Settings';
  @override
  String get weeklyStats => 'Week';
  @override
  String get monthlyStats => 'Month';
  @override
  String get streak => 'Streak';
  @override
  String get streakLabel => 'Streak';
  @override
  String get statsTitle => 'Statistics';
  @override
  String get goalReached => '🎉 Goal reached!';
  @override
  String get addFirstIntake => 'Add your first glass';
  @override
  String goalLoadError(String message) => 'Could not load goal: $message';
  @override
  String get retry => 'Retry';
  @override
  String get mlUnit => 'ml';
  @override
  String get averagePerDay => 'Average / day';
  @override
  String get daysGoalMet => 'Days with goal';
  @override
  String get profile => 'Profile';
  @override
  String get name => 'Name';
  @override
  String get notSet => 'Not set';
  @override
  String get nameHint => 'What should we call you?';
  @override
  String get nameFieldLabel => 'Name';
  @override
  String get reminderInterval => 'Interval';
  @override
  String get reminderFrom => 'From';
  @override
  String get reminderTo => 'To';
  @override
  String get reminderTest => 'Test notification';
  @override
  String get reminderTestTitle => 'Test';
  @override
  String get reminderTestBody => 'Notifications are configured';
  @override
  String get appearance => 'Appearance';
  @override
  String get themeSystem => 'System';
  @override
  String get themeLight => 'Light';
  @override
  String get themeDark => 'Dark';
  @override
  String get account => 'Account';
  @override
  String get about => 'About';
  @override
  String get version => 'Version';
  @override
  String get privacy => 'Privacy policy';
  @override
  String get privacyOpenFailed => 'Could not open link';
  @override
  String get logoutTitle => 'Sign out?';
  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String errorGeneric(String message) => 'Error: $message';
  @override
  String remindersError(String message) => 'Reminders: $message';
  @override
  String get minPassword => 'Password at least 6 characters';
  @override
  String get enterEmail => 'Enter email';
  @override
  String get invalidEmail => 'Invalid email';
  @override
  String get enterPassword => 'Enter password';
  @override
  String get noAccount => 'No account? Register';
  @override
  String get haveAccount => 'Already have an account? Log in';
  @override
  String get checkEmailConfirm => 'Check your email to confirm';
  @override
  String get registerSuccess => 'Registration successful';
  @override
  String get enterPasswordConfirm => 'Confirm password';
  @override
  String get passwordsMismatch => 'Passwords do not match';
  @override
  String get weightKg => 'Weight, kg';
  @override
  String get weightExample => 'e.g. 70';
  @override
  String get calculateByWeight => 'From weight';
  @override
  String minutesShort(int n) => '$n min';
  @override
  String get ok => 'OK';
  @override
  String get profileLoadError => 'Could not load profile';
  @override
  String get themeLoadError => 'Could not load theme';
  @override
  String get remindersLabel => 'Reminders';
  @override
  String mlFormat(int n) => '$n ml';
  @override
  String get addWaterAction => 'Add 250 ml';
  @override
  String get noData => 'No data';
  @override
  String get emptyCta => 'Add water';
  @override
  String get logoutFailed => 'Sign out failed';
}

class _Ru extends _LocData {
  @override
  String get appName => 'Трекер воды';
  @override
  String get appTitle => 'Трекер воды';
  @override
  String get homeTitle => 'Сегодня';
  @override
  String get addWater => 'Добавить воду';
  @override
  String addWaterWithMl(int ml) => '+$ml мл';
  @override
  String get todayHistory => 'История сегодня';
  @override
  String get goalTitle => 'Цель';
  @override
  String get dailyGoal => 'Дневная цель';
  @override
  String get reminders => 'Напоминания';
  @override
  String get login => 'Войти';
  @override
  String get register => 'Создать аккаунт';
  @override
  String get signUpCta => 'Зарегистрироваться';
  @override
  String get registerAppBar => 'Регистрация';
  @override
  String get email => 'Email';
  @override
  String get password => 'Пароль';
  @override
  String get confirmPassword => 'Повторите пароль';
  @override
  String get logout => 'Выйти';
  @override
  String get settings => 'Настройки';
  @override
  String get stats => 'Статистика';
  @override
  String get navHome => 'Home';
  @override
  String get navStats => 'Stats';
  @override
  String get navSettings => 'Settings';
  @override
  String get weeklyStats => 'Неделя';
  @override
  String get monthlyStats => 'Месяц';
  @override
  String get streak => 'Streak';
  @override
  String get streakLabel => 'Streak';
  @override
  String get statsTitle => 'Статистика';
  @override
  String get goalReached => '🎉 Цель достигнута!';
  @override
  String get addFirstIntake => 'Добавьте первый стакан';
  @override
  String goalLoadError(String message) => 'Не удалось загрузить цель: $message';
  @override
  String get retry => 'Повторить';
  @override
  String get mlUnit => 'мл';
  @override
  String get averagePerDay => 'Среднее / день';
  @override
  String get daysGoalMet => 'Дней с целью';
  @override
  String get profile => 'Профиль';
  @override
  String get name => 'Имя';
  @override
  String get notSet => 'Не указано';
  @override
  String get nameHint => 'Как вас зовут';
  @override
  String get nameFieldLabel => 'Имя';
  @override
  String get reminderInterval => 'Интервал';
  @override
  String get reminderFrom => 'С';
  @override
  String get reminderTo => 'До';
  @override
  String get reminderTest => 'Тестовое уведомление';
  @override
  String get reminderTestTitle => 'Тест';
  @override
  String get reminderTestBody => 'Уведомления настроены';
  @override
  String get appearance => 'Внешний вид';
  @override
  String get themeSystem => 'Системная';
  @override
  String get themeLight => 'Светлая';
  @override
  String get themeDark => 'Тёмная';
  @override
  String get account => 'Аккаунт';
  @override
  String get about => 'О приложении';
  @override
  String get version => 'Версия';
  @override
  String get privacy => 'Политика конфиденциальности';
  @override
  String get privacyOpenFailed => 'Не удалось открыть ссылку';
  @override
  String get logoutTitle => 'Выйти из аккаунта?';
  @override
  String get save => 'Сохранить';
  @override
  String get cancel => 'Отмена';
  @override
  String errorGeneric(String message) => 'Ошибка: $message';
  @override
  String remindersError(String message) => 'Напоминания: $message';
  @override
  String get minPassword => 'Пароль не менее 6 символов';
  @override
  String get enterEmail => 'Введите email';
  @override
  String get invalidEmail => 'Некорректный email';
  @override
  String get enterPassword => 'Введите пароль';
  @override
  String get noAccount => 'Нет аккаунта? Регистрация';
  @override
  String get haveAccount => 'Уже есть аккаунт? Войти';
  @override
  String get checkEmailConfirm => 'Проверьте почту для подтверждения';
  @override
  String get registerSuccess => 'Регистрация прошла успешно';
  @override
  String get enterPasswordConfirm => 'Повторите пароль';
  @override
  String get passwordsMismatch => 'Пароли не совпадают';
  @override
  String get weightKg => 'Вес, кг';
  @override
  String get weightExample => 'Напр. 70';
  @override
  String get calculateByWeight => 'Рассчитать по весу';
  @override
  String minutesShort(int n) => '$n мин';
  @override
  String get ok => 'OK';
  @override
  String get profileLoadError => 'Не удалось загрузить профиль';
  @override
  String get themeLoadError => 'Ошибка загрузки темы';
  @override
  String get remindersLabel => 'Напоминания';
  @override
  String mlFormat(int n) => '$n мл';
  @override
  String get addWaterAction => '+ 250 мл';
  @override
  String get noData => 'Нет данных';
  @override
  String get emptyCta => 'Добавить воду';
  @override
  String get logoutFailed => 'Не вышли';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      AppLocalizations._(
        locale.languageCode == 'ru' ? _Ru() : _En(),
      ),
    );
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
