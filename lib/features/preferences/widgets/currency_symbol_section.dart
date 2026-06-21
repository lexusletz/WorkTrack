import 'package:flutter/material.dart';

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

    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 10),
        Row(
          spacing: 10,
          children: symbols.entries
            .map<Widget>(
              (symbol) => _buildButton(
                symbol.key,
                symbol.value,
                colorScheme
              )
            ).toList(),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "03 • TIPO DE MONEDA",
          style: TextStyle(color: Color(0xFF9aa59e)),
        ),
        Text("USADA EN TODA LA APLICACION", style: TextStyle(color: Color(0xFF5c6b62))),
      ],
    );
  }

  Widget _buildButton(String symbol, String name, ColorScheme colorScheme) {
    final isSelected = isSymbolSelected(symbol);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          onChange(symbol);
        },
        child: AspectRatio(
          aspectRatio: 2.5,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadiusDirectional.circular(6),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
              )
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    symbol,
                    style: TextStyle(
                      fontSize: 32,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
