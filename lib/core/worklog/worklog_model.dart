import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../preferences/domain/preferences_model.dart';

enum DayStatus {
  /// When a day hasn't been registered.
  WORKDAY,

  /// No work day, holiday or absent
  NONWORKDAY
}

DayStatus dayStatusFor(DateTime day, WorkLog? log, Preferences preferences) {
    return preferences.workingDays.contains(day.weekday)
        ? DayStatus.WORKDAY
        : DayStatus.NONWORKDAY;
}

@immutable
class WorkLog {
  const WorkLog({
    required this.date,
    required this.hoursWorked,
  });

  final DateTime date;
  final double hoursWorked;

  static String keyFor(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String get key => keyFor(date);

  WorkLog copyWith({
    DateTime? date,
    double? hoursWorked,
  }) {
    return WorkLog(
      date: date ?? this.date,
      hoursWorked: hoursWorked ?? this.hoursWorked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkLog &&
          date == other.date &&
          hoursWorked == other.hoursWorked;

  @override
  int get hashCode => Object.hash(date, hoursWorked);
}

class WorkLogAdapter extends TypeAdapter<WorkLog> {
  @override
  final int typeId = 0;

  @override
  WorkLog read(BinaryReader reader) {
    return WorkLog(
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      hoursWorked: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkLog obj) {
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeDouble(obj.hoursWorked);
  }
}
