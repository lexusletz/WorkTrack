import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/double_utils.dart';

class TextNumberAnimation extends StatefulWidget {
  final num value;
  final TextStyle? style;
  final int decimals;
  final String? currencySymbol;
  final Duration duration;
  final Curve curve;

  const TextNumberAnimation({
    super.key,
    required this.duration,
    required this.value,
    this.decimals = 2,
    this.style,
    this.currencySymbol,
    this.curve = Curves.easeInOutCubicEmphasized,
  });

  @override
  State<TextNumberAnimation> createState() => _TextNumberAnimationState();
}

class _TextNumberAnimationState extends State<TextNumberAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  num _fromValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.forward();
  }

  @override
  void didUpdateWidget(TextNumberAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _fromValue = _fromValue + (oldWidget.value - _fromValue) * _animation.value;
      _controller
        ..duration = widget.duration
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  num get _currentValue =>
      _fromValue + (widget.value - _fromValue) * _animation.value;

  String _formatNumber(num value) {
    if (widget.currencySymbol != null) {
      return NumberFormat.currency(
        symbol: widget.currencySymbol,
        decimalDigits: widget.decimals,
      ).format(value);
    }

    if (value is double) {
      return value.toTime;
    }

    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Text(
        _formatNumber(_currentValue),
        style: widget.style,
      ),
    );
  }
}
