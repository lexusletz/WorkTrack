import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import 'preference_section.dart';

class HourlyRateSection extends StatefulWidget {
  const HourlyRateSection({
    required this.value,
    required this.symbol,
    required this.onChange,
    super.key,
  });

  final double value;
  final String symbol;
  final Function(double) onChange;

  @override
  State<HourlyRateSection> createState() => _HourlyRateSectionState();
}

class _HourlyRateSectionState extends State<HourlyRateSection> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.value.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PreferenceSection(
      title: l10n.sectionHourlyRateTitle,
      subtitle: l10n.sectionHourlyRateSubtitle,
      child: Container(
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
                    widget.symbol,
                    style: TextStyle(color: Color(0xFF9aa59e), fontSize: 22),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (String newValue) {
                        // We're sure that the String can be converted into a Double
                        widget.onChange(double.parse(newValue.isEmpty ? '0' : newValue));
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
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
    );
  }
}
