import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../preferences/preferences_screen.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  "W",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "WorkTrack",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PreferencesScreen()),
            );
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 2
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Icon(
                LucideIcons.settings,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
