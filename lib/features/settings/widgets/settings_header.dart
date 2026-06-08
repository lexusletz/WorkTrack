import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(LucideIcons.chevronLeft, color: Color(0xFF9aa59e)),
              Text("BACK", style: TextStyle(color: Color(0xFF9aa59e))),
            ],
          ),
        ),

        Row(
          children: [
            Text("SETTINGS", style: TextStyle(color: Color(0xFFf4f1e8))),
            Text(" · CONFIG", style: TextStyle(color: Color(0xFF9aa59e))),
          ],
        ),

        Row(
          spacing: 5,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF5c6b62), width: 1.5),
              ),
            ),
            Text("OK", style: TextStyle(color: Color(0xFF9aa59e))),
          ],
        ),
      ],
    );
  }
}
