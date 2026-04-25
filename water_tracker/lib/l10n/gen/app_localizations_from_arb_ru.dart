// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations_from_arb.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nFromArbRu extends L10nFromArb {
  L10nFromArbRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Трекер воды';

  @override
  String get appTitle => 'Трекер воды';

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
}
