import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_from_arb_en.dart';
import 'app_localizations_from_arb_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10nFromArb
/// returned by `L10nFromArb.of(context)`.
///
/// Applications need to include `L10nFromArb.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations_from_arb.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10nFromArb.localizationsDelegates,
///   supportedLocales: L10nFromArb.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10nFromArb.supportedLocales
/// property.
abstract class L10nFromArb {
  L10nFromArb(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10nFromArb? of(BuildContext context) {
    return Localizations.of<L10nFromArb>(context, L10nFromArb);
  }

  static const LocalizationsDelegate<L10nFromArb> delegate =
      _L10nFromArbDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CupOfWater'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CupOfWater'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTitle;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add water'**
  String get addWater;

  /// No description provided for @addWaterWithMl.
  ///
  /// In en, this message translates to:
  /// **'+{ml} ml'**
  String addWaterWithMl(int ml);

  /// No description provided for @todayHistory.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayHistory;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalTitle;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @weeklyStats.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weeklyStats;

  /// No description provided for @monthlyStats.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthlyStats;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'🎉 Goal reached!'**
  String get goalReached;

  /// No description provided for @addFirstIntake.
  ///
  /// In en, this message translates to:
  /// **'Add your first glass'**
  String get addFirstIntake;

  /// No description provided for @goalLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load goal: {message}'**
  String goalLoadError(String message);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @mlUnit.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlUnit;

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average / day'**
  String get averagePerDay;

  /// No description provided for @daysGoalMet.
  ///
  /// In en, this message translates to:
  /// **'Days with goal'**
  String get daysGoalMet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nameHint;

  /// No description provided for @nameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameFieldLabel;

  /// No description provided for @reminderInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get reminderInterval;

  /// No description provided for @reminderFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get reminderFrom;

  /// No description provided for @reminderTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get reminderTo;

  /// No description provided for @reminderTest.
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get reminderTest;

  /// No description provided for @reminderTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get reminderTestTitle;

  /// No description provided for @reminderTestBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are configured'**
  String get reminderTestBody;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy;

  /// No description provided for @privacyOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get privacyOpenFailed;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get logoutTitle;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account permanently?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. Your profile and all water history will be deleted.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed'**
  String get deleteAccountFailed;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @remindersError.
  ///
  /// In en, this message translates to:
  /// **'Reminders: {message}'**
  String remindersError(String message);

  /// No description provided for @minPassword.
  ///
  /// In en, this message translates to:
  /// **'Password at least 6 characters'**
  String get minPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Register'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get haveAccount;

  /// No description provided for @checkEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm'**
  String get checkEmailConfirm;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @enterPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get enterPasswordConfirm;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight, kg'**
  String get weightKg;

  /// No description provided for @weightExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. 70'**
  String get weightExample;

  /// No description provided for @calculateByWeight.
  ///
  /// In en, this message translates to:
  /// **'From weight'**
  String get calculateByWeight;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight (1–400 kg)'**
  String get invalidWeight;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutesShort(int n);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile'**
  String get profileLoadError;

  /// No description provided for @themeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load theme'**
  String get themeLoadError;

  /// No description provided for @remindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersLabel;

  /// No description provided for @mlFormat.
  ///
  /// In en, this message translates to:
  /// **'{n} ml'**
  String mlFormat(int n);

  /// No description provided for @addWaterAction.
  ///
  /// In en, this message translates to:
  /// **'Add 250 ml'**
  String get addWaterAction;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @emptyCta.
  ///
  /// In en, this message translates to:
  /// **'Add water'**
  String get emptyCta;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Drink water smarter'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'We\'ll estimate your personal target and send gentle reminders throughout the day.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'One tap — +250 ml'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Glass, bottle, coffee — log intake faster than finding your bottle.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'This helps us estimate your daily goal more accurately.'**
  String get onboardingBody3;

  /// No description provided for @onboardingWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get onboardingWeightLabel;

  /// No description provided for @onboardingKgSuffix.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get onboardingKgSuffix;

  /// No description provided for @onboardingSuggestedGoal.
  ///
  /// In en, this message translates to:
  /// **'Suggested goal'**
  String get onboardingSuggestedGoal;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @homeTodayHeader.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTodayHeader;

  /// No description provided for @homeMlLeft.
  ///
  /// In en, this message translates to:
  /// **'{n} ml left'**
  String homeMlLeft(String n);

  /// No description provided for @homeGoalDone.
  ///
  /// In en, this message translates to:
  /// **'Goal reached 🎉'**
  String get homeGoalDone;

  /// No description provided for @homeQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get homeQuickAdd;

  /// No description provided for @homeCustomVolume.
  ///
  /// In en, this message translates to:
  /// **'Custom volume'**
  String get homeCustomVolume;

  /// No description provided for @homeWeekMini.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeWeekMini;

  /// No description provided for @homeStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get homeStreakSubtitle;

  /// No description provided for @statsPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsPeriodWeek;

  /// No description provided for @statsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsPeriodMonth;

  /// No description provided for @statsPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsPeriodYear;

  /// No description provided for @statsAvgWeek.
  ///
  /// In en, this message translates to:
  /// **'Weekly average'**
  String get statsAvgWeek;

  /// No description provided for @statsMlPerDaySuffix.
  ///
  /// In en, this message translates to:
  /// **'ml / day'**
  String get statsMlPerDaySuffix;

  /// No description provided for @statsVsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'↑ {pct}% vs last week'**
  String statsVsLastWeek(int pct);

  /// No description provided for @statsVsLastWeekDown.
  ///
  /// In en, this message translates to:
  /// **'↓ {pct}% vs last week'**
  String statsVsLastWeekDown(int pct);

  /// No description provided for @statsGoalLine.
  ///
  /// In en, this message translates to:
  /// **'Goal {n}'**
  String statsGoalLine(String n);

  /// No description provided for @statsDaysGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Days with goal'**
  String get statsDaysGoalTitle;

  /// No description provided for @statsDaysGoalValue.
  ///
  /// In en, this message translates to:
  /// **'{met} / {total}'**
  String statsDaysGoalValue(int met, int total);

  /// No description provided for @statsBestDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get statsBestDayTitle;

  /// No description provided for @statsTotalWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Total this week'**
  String get statsTotalWeekTitle;

  /// No description provided for @statsLitersShort.
  ///
  /// In en, this message translates to:
  /// **'{n} L'**
  String statsLitersShort(String n);

  /// No description provided for @statsMonthGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get statsMonthGoalsTitle;

  /// No description provided for @statsMonthGoalsValue.
  ///
  /// In en, this message translates to:
  /// **'{met} / {total} d'**
  String statsMonthGoalsValue(int met, int total);

  /// No description provided for @statsMonthAvgTitle.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statsMonthAvgTitle;

  /// No description provided for @statsLitersPerDay.
  ///
  /// In en, this message translates to:
  /// **'{n} L / day'**
  String statsLitersPerDay(String n);

  /// No description provided for @statsHeatmapLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get statsHeatmapLess;

  /// No description provided for @statsHeatmapMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get statsHeatmapMore;

  /// No description provided for @statsYearTotalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly totals'**
  String get statsYearTotalsTitle;

  /// No description provided for @goalSection.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalSection;

  /// No description provided for @unitsSection.
  ///
  /// In en, this message translates to:
  /// **'Units & format'**
  String get unitsSection;

  /// No description provided for @volumeUnitMl.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volumeUnitMl;

  /// No description provided for @glassSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Glass size'**
  String get glassSizeTitle;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @accentColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColorTitle;

  /// No description provided for @accentOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get accentOcean;

  /// No description provided for @syncSection.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncSection;

  /// No description provided for @syncCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get syncCloudTitle;

  /// No description provided for @syncHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Apple Health / Google Fit'**
  String get syncHealthTitle;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// No description provided for @profileSeeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get profileSeeAll;

  /// No description provided for @profileDaysStat.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profileDaysStat;

  /// No description provided for @profileDrankStat.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get profileDrankStat;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String profileMemberSince(String date);

  /// No description provided for @profileRollingHint.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get profileRollingHint;

  /// No description provided for @activityMedium.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get activityMedium;

  /// No description provided for @weekdayInitialMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekdayInitialMon;

  /// No description provided for @weekdayInitialTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayInitialTue;

  /// No description provided for @weekdayInitialWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekdayInitialWed;

  /// No description provided for @weekdayInitialThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayInitialThu;

  /// No description provided for @weekdayInitialFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekdayInitialFri;

  /// No description provided for @weekdayInitialSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayInitialSat;

  /// No description provided for @weekdayInitialSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayInitialSun;

  /// No description provided for @intakeFromGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goalMl} ml'**
  String intakeFromGoal(int goalMl);
}

class _L10nFromArbDelegate extends LocalizationsDelegate<L10nFromArb> {
  const _L10nFromArbDelegate();

  @override
  Future<L10nFromArb> load(Locale locale) {
    return SynchronousFuture<L10nFromArb>(lookupL10nFromArb(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nFromArbDelegate old) => false;
}

L10nFromArb lookupL10nFromArb(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nFromArbEn();
    case 'ru':
      return L10nFromArbRu();
  }

  throw FlutterError(
    'L10nFromArb.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
