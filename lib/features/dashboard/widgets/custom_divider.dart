import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: colorScheme.primaryContainer),
    );
  }
}
