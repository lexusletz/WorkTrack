import 'package:flutter/material.dart';

class OptionsSection extends StatelessWidget {
  const OptionsSection({
    super.key,
    required this.onSave,
    this.isActive = false,
  });

  final VoidCallback onSave;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))
      ),
      padding: EdgeInsets.only(left: 18, right: 18, top: 12),
      child: GestureDetector(
        onTap: onSave,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "GUARDAR CAMBIOS",
              style: TextStyle(
                color: isActive ? colorScheme.surface : colorScheme.onSurface,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
