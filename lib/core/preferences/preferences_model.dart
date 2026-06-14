import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Preferences {
  const Preferences({
    required this.hourlyRate,
    required this.dailyTargetHours,
    required this.currency,
    required this.workingDays,
  });

  final double hourlyRate;
  final double dailyTargetHours;
  final String currency;
  final List<int> workingDays;

  static const defaults = Preferences(
    hourlyRate: 8.5,
    dailyTargetHours: 8,
    currency: r'$',
    workingDays: [],
  );

  Preferences copyWith({
    double? hourlyRate,
    double? dailyTargetHours,
    String? currency,
    List<int>? workingDays,
  }) {
    return Preferences(
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dailyTargetHours: dailyTargetHours ?? this.dailyTargetHours,
      currency: currency ?? this.currency,
      workingDays: workingDays ?? this.workingDays,
    );
  }

  Map<String, dynamic> toJson() => {
    'hourly_rate': hourlyRate,
    'daily_target_hours': dailyTargetHours,
    'currency': currency,
    'working_days': workingDays,
  };

  factory Preferences.fromJson(Map<String, dynamic> j) => Preferences(
    hourlyRate: (j['hourly_rate'] as num).toDouble(),
    dailyTargetHours: (j['daily_target_hours'] as num).toDouble(),
    currency: j['currency'] as String,
    workingDays: j['working_days'].cast<int>(),
  );

  String toJsonString() => jsonEncode(toJson());
  factory Preferences.fromJsonString(String s) =>
      Preferences.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preferences &&
          hourlyRate == other.hourlyRate &&
          dailyTargetHours == other.dailyTargetHours &&
          currency == other.currency &&
          workingDays == other.workingDays;

  @override
  int get hashCode =>
      Object.hash(hourlyRate, dailyTargetHours, currency, workingDays);
}
