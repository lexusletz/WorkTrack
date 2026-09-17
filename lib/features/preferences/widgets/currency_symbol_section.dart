import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'preference_section.dart';

class CurrencySymbolSection extends StatelessWidget {
  const CurrencySymbolSection({
    super.key,
    required this.selectedSymbol,
    required this.onChange,
  });

  final String selectedSymbol;
  final Function(String symbol) onChange;

  bool isSymbolSelected(String symbol) => selectedSymbol == symbol;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> symbols = {
      "\$": "DOLAR",
      "€": "EURO",
    };

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PreferenceSection(
    title: l10n.sectionCurrencySymbolTitle,
    subtitle: l10n.sectionCurrencySymbolSubtitle,
      child: Row(
        spacing: 10,
        children: symbols.entries
          .map<Widget>(
            (symbol) => _buildButton(
              symbol.key,
              symbol.value,
              colorScheme
            )
          ).toList(),
      ),
    );
  }

  Widget _buildButton(String symbol, String name, ColorScheme colorScheme) {
    final isSelected = isSymbolSelected(symbol);

    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(symbol),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 72,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadiusDirectional.circular(6),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 28,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
