import '../settings/settings_model.dart';
import '../worklog/worklog_model.dart';
import 'forecast_model.dart';

class ForecastEngine {
  static Forecast compute({
    required Settings settings,
    required List<WorkLog> monthLogs,
    required DateTime today,
  }) {
    final rate = settings.hourlyRate;
    final todayDate = DateTime(today.year, today.month, today.day);
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 0);

    final logsByKey = <String, WorkLog>{for (final l in monthLogs) l.key: l};

    double accumulated = 0;
    double remaining = 0;
    double target = 0;

    for (
      var d = monthStart;
      !d.isAfter(monthEnd);
      d = d.add(const Duration(days: 1))
    ) {
      final isWorkDay = settings.workingDays.contains(d.weekday);
      if (isWorkDay) target += settings.standardHoursPerDay * rate;

      final log = logsByKey[WorkLog.keyFor(d)];
      final isPastOrToday = !d.isAfter(todayDate);

      if (isPastOrToday) {
        accumulated += (log?.hoursWorked ?? 0) * rate;
      } else {
        if (log != null) {
          remaining += log.hoursWorked * rate;
        } else if (isWorkDay) {
          remaining += settings.standardHoursPerDay * rate;
        }
      }
    }

    return Forecast(
      accumulated: accumulated,
      remaining: remaining,
      estimate: accumulated + remaining,
      target: target,
    );
  }
}
