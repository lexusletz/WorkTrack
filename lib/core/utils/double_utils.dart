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

  String get toTime {
    if (this.isNaN || this.isInfinite) return "00";

    final integer = this.floor();

    // Extract the fractional part, convert it to minutes (base 60), and turn
    // it into an integer.
    int minutes = ((this - this.floor()) * 0.6 * 100).toInt();

    // Formats the time string, ensuring the minutes always have two digits.
    return "$integer:${minutes.toString().padLeft(2, '0')}";
  }
}
