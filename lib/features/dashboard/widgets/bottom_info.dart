import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_model.dart';
import '../../../core/settings/settings_providers.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../l10n/app_localizations.dart';

class BottomInfo extends ConsumerWidget {
  const BottomInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final AsyncValue<Settings> settingsAsync = ref.watch(settingsProvider);
    final double hourlyRate = settingsAsync.value?.hourlyRate ?? 0;
    final String symbol = settingsAsync.value?.currencySymbol ?? r'$';
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              l10n.hoursShortLabel.toUpperCase(),
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Text("30.00", style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        Row(
          children: [
            Text(
              l10n.dailyLogLabel,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Text("4/21", style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        Row(
          children: [
            Text(
              l10n.rateLabel.toUpperCase(),
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "${fmt(hourlyRate, symbol: symbol)}${l10n.perHourAbbreviation.toUpperCase()}",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
