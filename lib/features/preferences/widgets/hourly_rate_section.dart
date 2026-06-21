import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                      style: TextStyle(color: Color(0xFF9aa59e), fontSize: 22),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "8.5",
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // TextNumberAnimation(
                    //   value: value,
                    //   duration: const Duration(milliseconds: 850),
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 42,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   decimals: 2,
                    //   curve: Curves.fastOutSlowIn,
                    // ),
                    Text(
                      "/H",
                      style: TextStyle(color: Color(0xFF5c6b62), fontSize: 16),
                    ),
                  ],
                ),
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
        Text("01 • PRECIO POR HORA", style: TextStyle(color: Color(0xFF9aa59e))),
        Text(
          "CANTIDAD GANADA CADA HORA",
          style: TextStyle(color: Color(0xFF5c6b62)),
        ),
      ],
    );
  }
}
