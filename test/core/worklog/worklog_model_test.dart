import 'package:flutter_test/flutter_test.dart';
import 'package:worktrack/core/preferences/domain/preferences_model.dart';
import 'package:worktrack/core/worklog/worklog_model.dart';

void main() {
  group("dayStatusFor Tests", () {
    test('NonWorkDay not worked should return NONWORKDAY', () {
      final DateTime saturday = DateTime(2026, 9, 5);

      final WorkLog log = WorkLog(date: saturday, hoursWorked: 0);
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(saturday, log, preferences);

      expect(status, DayStatus.NONWORKDAY);
    });

    test('NonWorkDay worked should return WORKDAY', () {
      final DateTime saturday = DateTime(2026, 9, 5);

      final WorkLog log = WorkLog(date: saturday, hoursWorked: 8);
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(saturday, log, preferences);

      expect(status, DayStatus.WORKDAY);
    });

    test('NonWorkDay without log should return NONWORKDAY', () {
      final DateTime saturday = DateTime(2026, 9, 5);

      final WorkLog? log = null;
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(saturday, log, preferences);

      expect(status, DayStatus.NONWORKDAY);
    });

    test('WorkDay worked should return WORKDAY', () {
      final DateTime monday = DateTime(2026, 9, 7);

      final WorkLog log = WorkLog(date: monday, hoursWorked: 8);
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(monday, log, preferences);

      expect(status, DayStatus.WORKDAY);
    });

    test('WorkDay not worked should return WORKDAY', () {
      final DateTime monday = DateTime(2026, 9, 7);

      final WorkLog log = WorkLog(date: monday, hoursWorked: 0);
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(monday, log, preferences);

      expect(status, DayStatus.WORKDAY);
    });

    test('WorkDay without log should return WORKDAY', () {
      final DateTime monday = DateTime(2026, 9, 7);

      final WorkLog? log = null;
      final Preferences preferences = Preferences.defaults;

      final DayStatus status = dayStatusFor(monday, log, preferences);

      expect(status, DayStatus.WORKDAY);
    });
  });
}
