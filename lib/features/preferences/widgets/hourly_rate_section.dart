import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';

class HourlyRateSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildHeader(l10n),
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
                      symbol,
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

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Text(l10n.sectionHourlyRateTitle, style: const TextStyle(color: Color(0xFF9aa59e))),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            l10n.sectionHourlyRateSubtitle,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Color(0xFF5c6b62)),
          ),
        ),
      ],
    );
  }
}
