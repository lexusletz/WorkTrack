import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('es'),
  ];

  /// Title of the dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to WorkTrack'**
  String get dashboardTitle;

  /// Label for the accumulated hours
  ///
  /// In en, this message translates to:
  /// **'Accumulated'**
  String get accumulatedLabel;

  /// Label for the remaining hours
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingLabel;

  /// Label for the estimated hours
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get estimatedLabel;

  /// Label for the target hours
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get targetLabel;

  /// Label for the today button
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// Label for the select a day
  ///
  /// In en, this message translates to:
  /// **'Select a day to log hours'**
  String get selectADayLabel;

  /// Short for Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monShort;

  /// Short for Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tueShort;

  /// Short for Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wedShort;

  /// Short for Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thuShort;

  /// Short for Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friShort;

  /// Short for Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get satShort;

  /// Short for Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunShort;

  /// Number of hours worked on the selected day
  ///
  /// In en, this message translates to:
  /// **'Hours Worked'**
  String get hoursWorkedLabel;

  /// The abbreviation for hours
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursAbbreviation;

  /// Hint text for hours
  ///
  /// In en, this message translates to:
  /// **'0 = missed / holiday'**
  String get hoursHintText;

  /// Validation message for hours
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 0 and 24'**
  String get hoursValidationMessage;

  /// Label for extra day
  ///
  /// In en, this message translates to:
  /// **'Extra Day'**
  String get extraDayLabel;

  /// Hint text for extra day
  ///
  /// In en, this message translates to:
  /// **'Weekend or overtime'**
  String get extraDayHint;

  /// Label for notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Title of the settings dialog
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsDialogTitle;

  /// Label for the hourly rate
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRateLabel;

  /// Validation message for the hourly rate
  ///
  /// In en, this message translates to:
  /// **'Enter a rate greater than 0'**
  String get hourlyRateValidationMessage;

  /// Label for the working days
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDaysLabel;

  /// Label for the standard hours per day
  ///
  /// In en, this message translates to:
  /// **'Standard Hours per Day'**
  String get standardHoursLabel;

  /// Label for the currency symbol
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get currencySymbolLabel;

  /// Validation message for the currency symbol
  ///
  /// In en, this message translates to:
  /// **'Enter a currency symbol'**
  String get currencySymbolValidationMessage;

  /// Label for the font family
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamilyLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
