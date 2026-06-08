import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_providers.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../l10n/app_localizations.dart';

class ShiftSection extends ConsumerWidget {
  const ShiftSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final symbol = settingsAsync.value?.currencySymbol ?? r'$';
    final hourlyRate = settingsAsync.value?.hourlyRate ?? 0;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(4)
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: colorScheme.surface),
              ),
              SizedBox(width: 10),
              Text(
                l10n.startShiftLabel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),

          Text(
            "${fmt(hourlyRate, symbol: symbol)}${l10n.perHourAbbreviation.toUpperCase()}",
          ),
        ],
      ),
    );
  }
}
