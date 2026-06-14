import 'package:flutter/material.dart';

class CurrencySymbolSection extends StatelessWidget {
  const CurrencySymbolSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildHeader()]);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "03 • CURRENCY SYMBOL",
          style: TextStyle(color: Color(0xFF9aa59e)),
        ),
        Text("USED EVERYWHERE", style: TextStyle(color: Color(0xFF5c6b62))),
      ],
    );
  }
}
