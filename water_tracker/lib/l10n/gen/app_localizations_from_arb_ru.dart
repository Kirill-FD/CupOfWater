// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations_from_arb.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nFromArbRu extends L10nFromArb {
  L10nFromArbRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'CupOfWater';

  @override
  String get appTitle => 'CupOfWater';

  @override
  String get homeTitle => 'Сегодня';

  @override
  String get addWater => 'Добавить воду';

  @override
  String addWaterWithMl(int ml) {
    return '+$ml мл';
  }

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
  String goalLoadError(String message) {
    return 'Не удалось загрузить цель: $message';
  }

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
  String errorGeneric(String message) {
    return 'Ошибка: $message';
  }

  @override
  String remindersError(String message) {
    return 'Напоминания: $message';
  }

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
  String get languageSetting => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get invalidWeight => 'Укажите вес от 1 до 400 кг';

  @override
  String minutesShort(int n) {
    return '$n мин';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileLoadError => 'Не удалось загрузить профиль';

  @override
  String get themeLoadError => 'Ошибка загрузки темы';

  @override
  String get remindersLabel => 'Напоминания';

  @override
  String mlFormat(int n) {
    return '$n мл';
  }

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
  String get onboardingBody3 => 'Это поможет точнее рассчитать дневную цель.';

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
  String homeMlLeft(String n) {
    return '$n мл осталось';
  }

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
  String statsVsLastWeek(int pct) {
    return '↑ +$pct% к прошлой неделе';
  }

  @override
  String statsVsLastWeekDown(int pct) {
    return '↓ −$pct% к прошлой неделе';
  }

  @override
  String statsGoalLine(String n) {
    return 'Цель $n';
  }

  @override
  String get statsDaysGoalTitle => 'Дней с целью';

  @override
  String statsDaysGoalValue(int met, int total) {
    return '$met / $total';
  }

  @override
  String get statsBestDayTitle => 'Лучший день';

  @override
  String get statsTotalWeekTitle => 'Всего за неделю';

  @override
  String statsLitersShort(String n) {
    return '$n л';
  }

  @override
  String get statsMonthGoalsTitle => 'Цель достигнута';

  @override
  String statsMonthGoalsValue(int met, int total) {
    return '$met / $total дн';
  }

  @override
  String get statsMonthAvgTitle => 'Среднее';

  @override
  String statsLitersPerDay(String n) {
    return '$n л / день';
  }

  @override
  String get statsHeatmapLess => 'Меньше';

  @override
  String get statsHeatmapMore => 'Больше';

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
  String profileMemberSince(String date) {
    return 'В приложении с $date';
  }

  @override
  String get profileRollingHint => 'За 12 мес.';

  @override
  String get activityMedium => 'Средняя';

  @override
  String get weekdayInitialMon => 'П';

  @override
  String get weekdayInitialTue => 'В';

  @override
  String get weekdayInitialWed => 'С';

  @override
  String get weekdayInitialThu => 'Ч';

  @override
  String get weekdayInitialFri => 'П';

  @override
  String get weekdayInitialSat => 'С';

  @override
  String get weekdayInitialSun => 'В';

  @override
  String intakeFromGoal(int goalMl) {
    return 'из $goalMl мл';
  }
}
