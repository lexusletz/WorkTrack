import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PreferencesHeader extends StatelessWidget {
  const PreferencesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Icon(LucideIcons.chevronLeft, color: Color(0xFF9aa59e)),
          Text("ATRAS", style: TextStyle(color: Color(0xFF9aa59e))),
        ],
      ),
    );
  }
}
