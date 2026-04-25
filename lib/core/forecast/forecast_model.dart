import 'package:flutter/foundation.dart';

@immutable
class Forecast {
  const Forecast({
    required this.accumulated,
    required this.remaining,
    required this.estimate,
    required this.target,
  });

  final double accumulated;
  final double remaining;
  final double estimate;
  final double target;

  static const zero = Forecast(
    accumulated: 0,
    remaining: 0,
    estimate: 0,
    target: 0,
  );
}
