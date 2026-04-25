// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardTitle => 'Welcome to WorkTrack';

  @override
  String get accumulatedLabel => 'Accumulated';

  @override
  String get remainingLabel => 'Remaining';

  @override
  String get estimatedLabel => 'Estimated';

  @override
  String get targetLabel => 'Target';

  @override
  String get todayLabel => 'Today';

  @override
  String get selectADayLabel => 'Select a day to log hours';

  @override
  String get monShort => 'Mon';

  @override
  String get tueShort => 'Tue';

  @override
  String get wedShort => 'Wed';

  @override
  String get thuShort => 'Thu';

  @override
  String get friShort => 'Fri';

  @override
  String get satShort => 'Sat';

  @override
  String get sunShort => 'Sun';

  @override
  String get hoursWorkedLabel => 'Hours Worked';

  @override
  String get hoursAbbreviation => 'h';

  @override
  String get hoursHintText => '0 = missed / holiday';

  @override
  String get hoursValidationMessage => 'Enter a value between 0 and 24';

  @override
  String get extraDayLabel => 'Extra Day';

  @override
  String get extraDayHint => 'Weekend or overtime';

  @override
  String get notesLabel => 'Notes';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get settingsDialogTitle => 'Settings';

  @override
  String get hourlyRateLabel => 'Hourly Rate';

  @override
  String get hourlyRateValidationMessage => 'Enter a rate greater than 0';

  @override
  String get workingDaysLabel => 'Working Days';

  @override
  String get standardHoursLabel => 'Standard Hours per Day';

  @override
  String get currencySymbolLabel => 'Currency Symbol';

  @override
  String get currencySymbolValidationMessage => 'Enter a currency symbol';

  @override
  String get fontFamilyLabel => 'Font Family';
}
