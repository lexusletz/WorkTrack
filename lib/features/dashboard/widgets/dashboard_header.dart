import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/settings_screen.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final String month = DateFormat('MMMM').format(date);
    final String day = DateFormat('d').format(date);

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
        Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.liveLabel} • $month$day"
                  .toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
            )
          ],
        ),
      ],
    );
  }
}
