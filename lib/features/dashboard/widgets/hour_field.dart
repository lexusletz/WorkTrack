import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'text_number_animation.dart';

class HourField extends ConsumerStatefulWidget {
  const HourField({
    super.key,
    required this.value,
    required this.onChange
  });

  final double value;
  final Function(double) onChange;

  @override
  ConsumerState<HourField> createState() => _HourFieldState();
}

class _HourFieldState extends ConsumerState<HourField> {
  void incrementHours() {
    widget.onChange(widget.value + 0.5);
  }

  void decrementHours() {
    if (widget.value > 0) {
      widget.onChange(widget.value - 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(colorScheme, "-", decrementHours),
              Column(
                children: [
                  Text(
                    "HOURS",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextNumberAnimation(
                    duration: Duration(milliseconds: 850),
                    value: widget.value,
                    style: TextStyle(
                      color: const Color(0xFFf4f1e8),
                      fontSize: 48,
                      fontWeight: FontWeight.w500
                    ),
                    decimals: 2,
                    curve: Curves.easeOutCubic,
                  ),
                ],
              ),
              _buildButton(colorScheme, "+", incrementHours),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          spacing: 6,
          children: [
            Expanded(
              child: _buildPredefinedButton(colorScheme, 4, widget.value == 4),
            ),
            Expanded(
              child: _buildPredefinedButton(colorScheme, 6, widget.value == 6),
            ),
            Expanded(
              child: _buildPredefinedButton(colorScheme, 8, widget.value == 8),
            ),
            Expanded(
              child: _buildPredefinedButton(colorScheme, 9, widget.value == 9),
            )
          ],
        )
      ],
    );
  }

  GestureDetector _buildPredefinedButton(ColorScheme colorScheme, double value, bool selected) {
    return GestureDetector(
      onTap: () {
        widget.onChange(value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 36,
        decoration: BoxDecoration(
          color: selected
            ? Color(0xFF2C4334)
            : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? colorScheme.primary : colorScheme.outline)
        ),
        child: Center(
          child: Text(
            "${value.toInt()}h",
            style: TextStyle(color: Color(0xFFf4f1e8)),
          )
        ),
      ),
    );
  }

  GestureDetector _buildButton(
    ColorScheme colorScheme,
    String text,
    VoidCallback onTap
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF9aa59e),
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
