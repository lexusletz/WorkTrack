import 'package:flutter/foundation.dart';

@immutable
class Forecast {
  const Forecast({
    required this.accumulated,
    required this.remaining,
    required this.remainingDays,
    required this.estimate,
    required this.target,
  });

  /// The total estimated earnings in the current month.
  final double accumulated;

  /// The total estimated earnings for the remaining work in the current month.
  final double remaining;

  /// The number of working days remaining in the current month.
  final int remainingDays;

  /// The total estimated earnings in the current month.
  final double estimate;

  /// The total estimated earnings for the month if all work is completed.
  final double target;

  static const zero = Forecast(
    accumulated: 0,
    remaining: 0,
    remainingDays: 0,
    estimate: 0,
    target: 0,
  );
}
