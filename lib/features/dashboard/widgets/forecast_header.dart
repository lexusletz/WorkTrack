import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/forecast/forecast_providers.dart';
import '../../../core/settings/settings_providers.dart';
import 'stat_card.dart';

class ForecastHeader extends ConsumerWidget {
  const ForecastHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(forecastProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final symbol = settingsAsync.valueOrNull?.currencySymbol ?? r'$';

    String fmt(double v) =>
        NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(v);

    return forecastAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Forecast error: $e'),
      ),
      data: (f) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Expanded(child: StatCard(label: 'Accumulated', value: fmt(f.accumulated))),
            const SizedBox(width: 8),
            Expanded(child: StatCard(label: 'Remaining', value: fmt(f.remaining))),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                label: 'Estimate',
                value: fmt(f.estimate),
                emphasized: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: StatCard(label: 'Target', value: fmt(f.target))),
          ],
        ),
      ),
    );
  }
}
