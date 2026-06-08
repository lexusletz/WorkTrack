import 'package:flutter/material.dart';

import '../../dashboard/widgets/text_number_animation.dart';

class HourlyRateSection extends StatelessWidget {
  const HourlyRateSection({
    required this.value,
    required this.onChange,
    super.key,
  });

  final double value;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "\$",
                      style: TextStyle(
                        color: Color(0xFF9aa59e),
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(width: 8),
                    TextNumberAnimation(
                      value: value,
                      duration: const Duration(milliseconds: 850),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                      decimals: 2,
                      curve: Curves.fastOutSlowIn,
                    ),
                    Spacer(),
                    Text(
                      "/H",
                      style: TextStyle(
                        color: Color(0xFF5c6b62),
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Column(
                spacing: 5,
                children: [
                  _buildCounterButton(
                    colorScheme,
                    "+",
                    () {
                      onChange(value + 0.5);
                    }
                  ),
                  _buildCounterButton(
                    colorScheme,
                    "-",
                    () {
                      onChange(value - 0.5);
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "01 • HOURLY RATE",
          style: TextStyle(color: Color(0xFF9aa59e)),
        ),
        Text(
          "AMOUNT EARNED PER HOUR",
          style: TextStyle(color: Color(0xFF5c6b62)),
        ),
      ],
    );
  }

  Widget _buildCounterButton(ColorScheme colorScheme, String text, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 34,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFFf4f1e8),
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}
