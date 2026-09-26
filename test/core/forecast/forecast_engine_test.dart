import 'package:flutter_test/flutter_test.dart';
import 'package:worktrack/core/forecast/forecast_engine.dart';
import 'package:worktrack/core/forecast/forecast_model.dart';
import 'package:worktrack/core/preferences/domain/preferences_model.dart';
import 'package:worktrack/core/worklog/worklog_model.dart';

void main() {
  Preferences preferences = Preferences(
    hourlyRate: 10,
    dailyTargetHours: 8,
    currency: r'$',
    workingDays: [1],
  );

  group("ForecastEngine Tests", () {
    test('Baseline with out logs', () {
      final DateTime today = DateTime(2026, 9, 1);
      final DateTime month = DateTime(2026, 9, 1);
      final List<WorkLog> monthLogs = [];

      Forecast forecast = ForecastEngine.compute(
        preferences: preferences,
        monthLogs: monthLogs,
        today: today,
        month: month,
      );

      expect(forecast.remaining, 320);
      expect(forecast.remainingDays, 4);
      expect(forecast.estimate, 320);
    });

    test("Log '0' on a future day", () {
      final DateTime today = DateTime(2026, 9, 1);
      final DateTime month = DateTime(2026, 9, 1);
      final List<WorkLog> monthLogs = [
        WorkLog(date: DateTime(2026, 9, 14), hoursWorked: 0),
      ];

      Forecast forecast = ForecastEngine.compute(
        preferences: preferences,
        monthLogs: monthLogs,
        today: today,
        month: month,
      );

      expect(forecast.remaining, 240);
      expect(forecast.remainingDays, 3);
      expect(forecast.estimate, 240);
    });

    test("Partial log on a future day", () {
      final DateTime today = DateTime(2026, 9, 1);
      final DateTime month = DateTime(2026, 9, 1);
      final List<WorkLog> monthLogs = [
        WorkLog(date: DateTime(2026, 9, 21), hoursWorked: 6),
      ];

      Forecast forecast = ForecastEngine.compute(
        preferences: preferences,
        monthLogs: monthLogs,
        today: today,
        month: month,
      );

      expect(forecast.remaining, 300);
      expect(forecast.remainingDays, 4);
    });

    test("Logs on past days accumulate", () {
      final DateTime today = DateTime(2026, 9, 22);
      final DateTime month = DateTime(2026, 9, 1);
      final List<WorkLog> monthLogs = [
        WorkLog(date: DateTime(2026, 9, 7), hoursWorked: 7),
        WorkLog(date: DateTime(2026, 9, 14), hoursWorked: 5),
      ];

      Forecast forecast = ForecastEngine.compute(
        preferences: preferences,
        monthLogs: monthLogs,
        today: today,
        month: month,
      );

      expect(forecast.accumulated, 120);
      expect(forecast.remainingDays, 1);
      expect(forecast.estimate, 200);
      expect(forecast.target, 320);
    });

    test("Weekend work with log >0 counts", () {
      final DateTime today = DateTime(2026, 9, 1);
      final DateTime month = DateTime(2026, 9, 1);
      final List<WorkLog> monthLogs = [
        WorkLog(date: DateTime(2026, 9, 12), hoursWorked: 5),
      ];

      Forecast forecast = ForecastEngine.compute(
        preferences: preferences,
        monthLogs: monthLogs,
        today: today,
        month: month,
      );

      expect(forecast.remaining, 370);
      expect(forecast.remainingDays, 5);
    });
  });
}
