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
  String get deleteAccount => _d.deleteAccount;
  String get deleteAccountTitle => _d.deleteAccountTitle;
  String get deleteAccountMessage => _d.deleteAccountMessage;
  String get deleteAccountConfirm => _d.deleteAccountConfirm;
  String get deleteAccountSuccess => _d.deleteAccountSuccess;
  String get deleteAccountFailed => _d.deleteAccountFailed;
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

  String get onboardingTitle1 => _d.onboardingTitle1;
  String get onboardingBody1 => _d.onboardingBody1;
  String get onboardingTitle2 => _d.onboardingTitle2;
  String get onboardingBody2 => _d.onboardingBody2;
  String get onboardingTitle3 => _d.onboardingTitle3;
  String get onboardingBody3 => _d.onboardingBody3;
  String get onboardingWeightLabel => _d.onboardingWeightLabel;
  String get onboardingKgSuffix => _d.onboardingKgSuffix;
  String get onboardingSuggestedGoal => _d.onboardingSuggestedGoal;
  String get onboardingNext => _d.onboardingNext;
  String get onboardingStart => _d.onboardingStart;
  String get onboardingSkip => _d.onboardingSkip;

  String get homeTodayHeader => _d.homeTodayHeader;
  String homeMlLeft(String n) => _d.homeMlLeft(n);
  String get homeGoalDone => _d.homeGoalDone;
  String get homeQuickAdd => _d.homeQuickAdd;
  String get homeCustomVolume => _d.homeCustomVolume;
  String get homeWeekMini => _d.homeWeekMini;
  String get homeStreakSubtitle => _d.homeStreakSubtitle;
  String intakeFromGoal(int goalMl) => _d.intakeFromGoal(goalMl);

  String get statsPeriodWeek => _d.statsPeriodWeek;
  String get statsPeriodMonth => _d.statsPeriodMonth;
  String get statsPeriodYear => _d.statsPeriodYear;
  String get statsAvgWeek => _d.statsAvgWeek;
  String get statsMlPerDaySuffix => _d.statsMlPerDaySuffix;
  String statsVsLastWeek(int pct) => _d.statsVsLastWeek(pct);
  String statsVsLastWeekDown(int pct) => _d.statsVsLastWeekDown(pct);
  String get statsDaysGoalTitle => _d.statsDaysGoalTitle;
  String statsDaysGoalValue(int met, int total) =>
      _d.statsDaysGoalValue(met, total);
  String get statsBestDayTitle => _d.statsBestDayTitle;
  String get statsTotalWeekTitle => _d.statsTotalWeekTitle;
  String statsLitersShort(String n) => _d.statsLitersShort(n);
  String statsGoalLine(String n) => _d.statsGoalLine(n);
  String get statsHeatmapLess => _d.statsHeatmapLess;
  String get statsHeatmapMore => _d.statsHeatmapMore;
  String get statsMonthGoalsTitle => _d.statsMonthGoalsTitle;
  String statsMonthGoalsValue(int met, int total) =>
      _d.statsMonthGoalsValue(met, total);
  String get statsMonthAvgTitle => _d.statsMonthAvgTitle;
  String statsLitersPerDay(String n) => _d.statsLitersPerDay(n);
  String get statsYearTotalsTitle => _d.statsYearTotalsTitle;

  String get goalSection => _d.goalSection;
  String get unitsSection => _d.unitsSection;
  String get volumeUnitMl => _d.volumeUnitMl;
  String get glassSizeTitle => _d.glassSizeTitle;
  String get appearanceSection => _d.appearanceSection;
  String get accentColorTitle => _d.accentColorTitle;
  String get accentOcean => _d.accentOcean;
  String get syncSection => _d.syncSection;
  String get syncCloudTitle => _d.syncCloudTitle;
  String get syncHealthTitle => _d.syncHealthTitle;
  String get profileAchievements => _d.profileAchievements;
  String get profileSeeAll => _d.profileSeeAll;
  String get profileDaysStat => _d.profileDaysStat;
  String get profileDrankStat => _d.profileDrankStat;
  String profileMemberSince(String date) => _d.profileMemberSince(date);
  String get profileRollingHint => _d.profileRollingHint;
  String get activityMedium => _d.activityMedium;
  String get profileActivity => _d.profileActivity;
  String get languageSetting => _d.languageSetting;
  String get languageEnglish => _d.languageEnglish;
  String get languageRussian => _d.languageRussian;
  String get invalidWeight => _d.invalidWeight;
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
  String get deleteAccount;
  String get deleteAccountTitle;
  String get deleteAccountMessage;
  String get deleteAccountConfirm;
  String get deleteAccountSuccess;
  String get deleteAccountFailed;
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

  String get onboardingTitle1;
  String get onboardingBody1;
  String get onboardingTitle2;
  String get onboardingBody2;
  String get onboardingTitle3;
  String get onboardingBody3;
  String get onboardingWeightLabel;
  String get onboardingKgSuffix;
  String get onboardingSuggestedGoal;
  String get onboardingNext;
  String get onboardingStart;
  String get onboardingSkip;

  String get homeTodayHeader;
  String homeMlLeft(String n);
  String get homeGoalDone;
  String get homeQuickAdd;
  String get homeCustomVolume;
  String get homeWeekMini;
  String get homeStreakSubtitle;
  String intakeFromGoal(int goalMl);

  String get statsPeriodWeek;
  String get statsPeriodMonth;
  String get statsPeriodYear;
  String get statsAvgWeek;
  String get statsMlPerDaySuffix;
  String statsVsLastWeek(int pct);
  String statsVsLastWeekDown(int pct);
  String get statsDaysGoalTitle;
  String statsDaysGoalValue(int met, int total);
  String get statsBestDayTitle;
  String get statsTotalWeekTitle;
  String statsLitersShort(String n);
  String statsGoalLine(String n);
  String get statsHeatmapLess;
  String get statsHeatmapMore;
  String get statsMonthGoalsTitle;
  String statsMonthGoalsValue(int met, int total);
  String get statsMonthAvgTitle;
  String statsLitersPerDay(String n);
  String get statsYearTotalsTitle;

  String get goalSection;
  String get unitsSection;
  String get volumeUnitMl;
  String get glassSizeTitle;
  String get appearanceSection;
  String get accentColorTitle;
  String get accentOcean;
  String get syncSection;
  String get syncCloudTitle;
  String get syncHealthTitle;
  String get profileAchievements;
  String get profileSeeAll;
  String get profileDaysStat;
  String get profileDrankStat;
  String profileMemberSince(String date);
  String get profileRollingHint;
  String get activityMedium;
  String get profileActivity;
  String get languageSetting;
  String get languageEnglish;
  String get languageRussian;
  String get invalidWeight;
}

class _En extends _LocData {
  @override
  String get appName => 'CupOfWater';
  @override
  String get appTitle => 'CupOfWater';
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
  String get deleteAccount => 'Delete account';
  @override
  String get deleteAccountTitle => 'Delete account permanently?';
  @override
  String get deleteAccountMessage =>
      'This action is irreversible. Your profile and all water history will be deleted.';
  @override
  String get deleteAccountConfirm => 'Delete';
  @override
  String get deleteAccountSuccess => 'Account deleted';
  @override
  String get deleteAccountFailed => 'Account deletion failed';
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
  String get onboardingTitle1 => 'Drink water smarter';
  @override
  String get onboardingBody1 =>
      'We\'ll estimate your personal target and send gentle reminders throughout the day.';
  @override
  String get onboardingTitle2 => 'One tap — +250 ml';
  @override
  String get onboardingBody2 =>
      'Glass, bottle, coffee — log intake faster than finding your bottle.';
  @override
  String get onboardingTitle3 => 'Tell us about you';
  @override
  String get onboardingBody3 =>
      'This helps us estimate your daily goal more accurately.';
  @override
  String get onboardingWeightLabel => 'Weight';
  @override
  String get onboardingKgSuffix => 'kg';
  @override
  String get onboardingSuggestedGoal => 'Suggested goal';
  @override
  String get onboardingNext => 'Next';
  @override
  String get onboardingStart => 'Get started';
  @override
  String get onboardingSkip => 'Skip';
  @override
  String get homeTodayHeader => 'Today';
  @override
  String homeMlLeft(String n) => '$n ml left';
  @override
  String get homeGoalDone => 'Goal reached 🎉';
  @override
  String get homeQuickAdd => 'Quick add';
  @override
  String get homeCustomVolume => 'Custom volume';
  @override
  String get homeWeekMini => 'This week';
  @override
  String get homeStreakSubtitle => 'day streak';
  @override
  String intakeFromGoal(int goalMl) => 'of $goalMl ml';
  @override
  String get statsPeriodWeek => 'Week';
  @override
  String get statsPeriodMonth => 'Month';
  @override
  String get statsPeriodYear => 'Year';
  @override
  String get statsAvgWeek => 'Weekly average';
  @override
  String get statsMlPerDaySuffix => 'ml / day';
  @override
  String statsVsLastWeek(int pct) => '↑ +$pct% vs last week';
  @override
  String statsVsLastWeekDown(int pct) => '↓ $pct% vs last week';
  @override
  String get statsDaysGoalTitle => 'Days with goal';
  @override
  String statsDaysGoalValue(int met, int total) => '$met / $total';
  @override
  String get statsBestDayTitle => 'Best day';
  @override
  String get statsTotalWeekTitle => 'Total this week';
  @override
  String statsLitersShort(String n) => '$n L';
  @override
  String statsGoalLine(String n) => 'Goal $n';
  @override
  String get statsHeatmapLess => 'Less';
  @override
  String get statsHeatmapMore => 'More';
  @override
  String get statsMonthGoalsTitle => 'Goal reached';
  @override
  String statsMonthGoalsValue(int met, int total) => '$met / $total d';
  @override
  String get statsMonthAvgTitle => 'Average';
  @override
  String statsLitersPerDay(String n) => '$n L / day';
  @override
  String get statsYearTotalsTitle => 'Monthly totals';
  @override
  String get goalSection => 'Goal';
  @override
  String get unitsSection => 'Units & format';
  @override
  String get volumeUnitMl => 'Volume';
  @override
  String get glassSizeTitle => 'Glass size';
  @override
  String get appearanceSection => 'Appearance';
  @override
  String get accentColorTitle => 'Accent color';
  @override
  String get accentOcean => 'Ocean';
  @override
  String get syncSection => 'Sync';
  @override
  String get syncCloudTitle => 'Cloud sync';
  @override
  String get syncHealthTitle => 'Apple Health / Google Fit';
  @override
  String get profileAchievements => 'Achievements';
  @override
  String get profileSeeAll => 'All';
  @override
  String get profileDaysStat => 'days';
  @override
  String get profileDrankStat => 'total';
  @override
  String profileMemberSince(String date) => 'Member since $date';
  @override
  String get profileRollingHint => 'Last 12 months';
  @override
  String get activityMedium => 'Moderate';
  @override
  String get profileActivity => 'Activity';
  @override
  String get languageSetting => 'Language';
  @override
  String get languageEnglish => 'English';
  @override
  String get languageRussian => 'Russian';
  @override
  String get invalidWeight => 'Enter a valid weight (1–400 kg)';
  @override
  String get logoutFailed => 'Sign out failed';
}

class _Ru extends _LocData {
  @override
  String get appName => 'CupOfWater';
  @override
  String get appTitle => 'CupOfWater';
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
  String get deleteAccount => 'Удалить аккаунт';
  @override
  String get deleteAccountTitle => 'Удалить аккаунт навсегда?';
  @override
  String get deleteAccountMessage =>
      'Это действие необратимо. Профиль и вся история воды будут удалены.';
  @override
  String get deleteAccountConfirm => 'Удалить';
  @override
  String get deleteAccountSuccess => 'Аккаунт удален';
  @override
  String get deleteAccountFailed => 'Не удалось удалить аккаунт';
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
  String get onboardingTitle1 => 'Пейте воду\nпо науке';
  @override
  String get onboardingBody1 =>
      'Мы рассчитаем вашу личную норму и будем мягко напоминать в течение дня.';
  @override
  String get onboardingTitle2 => 'Один тап —\n+250 мл';
  @override
  String get onboardingBody2 =>
      'Стакан, бутылка — добавляйте любой объем быстрее.';
  @override
  String get onboardingTitle3 => 'Расскажите\nо себе';
  @override
  String get onboardingBody3 =>
      'Это поможет точнее рассчитать дневную цель.';
  @override
  String get onboardingWeightLabel => 'Вес';
  @override
  String get onboardingKgSuffix => 'кг';
  @override
  String get onboardingSuggestedGoal => 'Рекомендуемая цель';
  @override
  String get onboardingNext => 'Дальше';
  @override
  String get onboardingStart => 'Начать';
  @override
  String get onboardingSkip => 'Пропустить';
  @override
  String get homeTodayHeader => 'Сегодня';
  @override
  String homeMlLeft(String n) => '$n мл осталось';
  @override
  String get homeGoalDone => 'Цель достигнута 🎉';
  @override
  String get homeQuickAdd => 'Быстрое добавление';
  @override
  String get homeCustomVolume => 'Свой объём';
  @override
  String get homeWeekMini => 'За неделю';
  @override
  String get homeStreakSubtitle => 'дней подряд';
  @override
  String intakeFromGoal(int goalMl) => 'из $goalMl мл';
  @override
  String get statsPeriodWeek => 'Неделя';
  @override
  String get statsPeriodMonth => 'Месяц';
  @override
  String get statsPeriodYear => 'Год';
  @override
  String get statsAvgWeek => 'Среднее за неделю';
  @override
  String get statsMlPerDaySuffix => 'мл / день';
  @override
  String statsVsLastWeek(int pct) => '↑ +$pct% к прошлой неделе';
  @override
  String statsVsLastWeekDown(int pct) => '↓ −$pct% к прошлой неделе';
  @override
  String get statsDaysGoalTitle => 'Дней с целью';
  @override
  String statsDaysGoalValue(int met, int total) => '$met / $total';
  @override
  String get statsBestDayTitle => 'Лучший день';
  @override
  String get statsTotalWeekTitle => 'Всего за неделю';
  @override
  String statsLitersShort(String n) => '$n л';
  @override
  String statsGoalLine(String n) => 'Цель $n';
  @override
  String get statsHeatmapLess => 'Меньше';
  @override
  String get statsHeatmapMore => 'Больше';
  @override
  String get statsMonthGoalsTitle => 'Цель достигнута';
  @override
  String statsMonthGoalsValue(int met, int total) => '$met / $total дн';
  @override
  String get statsMonthAvgTitle => 'Среднее';
  @override
  String statsLitersPerDay(String n) => '$n л / день';
  @override
  String get statsYearTotalsTitle => 'По месяцам';
  @override
  String get goalSection => 'Цель';
  @override
  String get unitsSection => 'Единицы и формат';
  @override
  String get volumeUnitMl => 'Объём';
  @override
  String get glassSizeTitle => 'Размер стакана';
  @override
  String get appearanceSection => 'Внешний вид';
  @override
  String get accentColorTitle => 'Акцентный цвет';
  @override
  String get accentOcean => 'Океан';
  @override
  String get syncSection => 'Синхронизация';
  @override
  String get syncCloudTitle => 'Облачная синхронизация';
  @override
  String get syncHealthTitle => 'Apple Health / Google Fit';
  @override
  String get profileAchievements => 'Достижения';
  @override
  String get profileSeeAll => 'Все';
  @override
  String get profileDaysStat => 'дней';
  @override
  String get profileDrankStat => 'выпито';
  @override
  String profileMemberSince(String date) => 'В приложении с $date';
  @override
  String get profileRollingHint => 'За 12 мес.';
  @override
  String get activityMedium => 'Средняя';
  @override
  String get profileActivity => 'Активность';
  @override
  String get languageSetting => 'Язык';
  @override
  String get languageEnglish => 'English';
  @override
  String get languageRussian => 'Русский';
  @override
  String get invalidWeight => 'Укажите вес от 1 до 400 кг';
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
