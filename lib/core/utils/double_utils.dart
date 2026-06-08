extension NumUtils on num {
  String toPercentageString({int fractionDigits = 2}) {
    return this.isFinite ? this.toStringAsFixed(fractionDigits) : '0';
  }
}

extension DoubleUtils on double {
  double get toProgress {
    if (this.isNaN || this.isInfinite) return 0.0;

    return this.clamp(0.0, 1.0);
  }
}
