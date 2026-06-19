import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/forecast/forecast_providers.dart';
import '../../../core/preferences/providers/preferences_providers.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../l10n/app_localizations.dart';
import 'custom_divider.dart';

class AmountsSection extends ConsumerWidget {
  const AmountsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final forecastAsync = ref.watch(forecastProvider);
    final settinsAsync = ref.watch(preferencesProvider);
    final l10n = AppLocalizations.of(context)!;

    final symbol = settinsAsync.value?.currency ?? r'$';

    return forecastAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text(e.toString()),
      data: (f) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDivider(),
          _AmountItem(
            title: l10n.estimatedLabel.toUpperCase(),
            subtitle: l10n.projectionLabel,
            value: fmt(f.estimate, symbol: symbol),
            valueColor: colorScheme.primary,
          ),
          CustomDivider(),
          _AmountItem(
            title: l10n.remainingLabel.toUpperCase(),
            subtitle: "${f.remainingDays}${l10n.remainingDaysLabel}",
            value: fmt(f.remaining, symbol: symbol),
            valueColor: colorScheme.tertiary,
          ),
          CustomDivider(),
        ],
      ),
    );
  }
}

class _AmountItem extends StatelessWidget {
  const _AmountItem({
    required this.title,
    required this.subtitle,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String title;
  final String subtitle;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: colorScheme.onSurfaceVariant)),

        Row(
          children: [
            Text(
              subtitle,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            SizedBox(width: 10),
            Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
