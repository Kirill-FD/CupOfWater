// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations_from_arb.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nFromArbEn extends L10nFromArb {
  L10nFromArbEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Water tracker';

  @override
  String get appTitle => 'Water Tracker';

  @override
  String get homeTitle => 'Today';

  @override
  String get addWater => 'Add water';

  @override
  String addWaterWithMl(int ml) {
    return '+$ml ml';
  }

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
  String goalLoadError(String message) {
    return 'Could not load goal: $message';
  }

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
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String remindersError(String message) {
    return 'Reminders: $message';
  }

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
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get ok => 'OK';

  @override
  String get profileLoadError => 'Could not load profile';

  @override
  String get themeLoadError => 'Could not load theme';

  @override
  String get remindersLabel => 'Reminders';

  @override
  String mlFormat(int n) {
    return '$n ml';
  }

  @override
  String get addWaterAction => 'Add 250 ml';

  @override
  String get noData => 'No data';

  @override
  String get emptyCta => 'Add water';
}
