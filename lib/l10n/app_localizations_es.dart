// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get dashboardTitle => 'Bienvenido a WorkTrack';

  @override
  String get accumulatedLabel => 'Acumulado';

  @override
  String get remainingLabel => 'Restante';

  @override
  String get estimatedLabel => 'Estimado';

  @override
  String get targetLabel => 'Objetivo';

  @override
  String get todayLabel => 'Hoy';

  @override
  String get selectADayLabel => 'Seleccionar un día para registrar horas';

  @override
  String get monShort => 'Lun';

  @override
  String get tueShort => 'Mar';

  @override
  String get wedShort => 'Mié';

  @override
  String get thuShort => 'Jue';

  @override
  String get friShort => 'Vie';

  @override
  String get satShort => 'Sáb';

  @override
  String get sunShort => 'Dom';

  @override
  String get hoursWorkedLabel => 'Horas Trabajadas';

  @override
  String get hoursAbbreviation => 'h';

  @override
  String get hoursHintText => '0 = Faltado / Vacaciones';

  @override
  String get hoursValidationMessage => 'Ingresa un valor entre 0 y 24';

  @override
  String get extraDayLabel => 'Día extra';

  @override
  String get extraDayHint => 'Fin de semana o tiempo extra';

  @override
  String get notesLabel => 'Notas';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Limpiar';

  @override
  String get settingsDialogTitle => 'Configuración';

  @override
  String get hourlyRateLabel => 'Precio por hora';

  @override
  String get hourlyRateValidationMessage => 'Ingresa un precio mayor a 0';

  @override
  String get workingDaysLabel => 'Días a trabajar';

  @override
  String get standardHoursLabel => 'Número de horas por día';

  @override
  String get currencySymbolLabel => 'Tipo de moneda';

  @override
  String get currencySymbolValidationMessage => 'Ingresa un tipo de moneda';

  @override
  String get fontFamilyLabel => 'Tipo de letra';
}
