import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/forecast/forecast_providers.dart';
import '../state/dashboard_providers.dart';

class MonthNavigator extends ConsumerWidget {
  const MonthNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browsedMonth = ref.watch(browsedMonthProvider);
    final now = ref.read(nowProvider);
    final currentMonth = DateTime(now.year, now.month);
    final isCurrentMonth = browsedMonth == currentMonth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(browsedMonthProvider.notifier).state = DateTime(
                browsedMonth.year,
                browsedMonth.month - 1,
              );
              ref.read(selectedDayProvider.notifier).state = null;
            },
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMM().format(browsedMonth),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: isCurrentMonth
                ? null
                : () {
                    ref.read(browsedMonthProvider.notifier).state = DateTime(
                      browsedMonth.year,
                      browsedMonth.month + 1,
                    );
                    ref.read(selectedDayProvider.notifier).state = null;
                  },
          ),
          TextButton(
            onPressed: isCurrentMonth
                ? null
                : () {
                    ref.read(browsedMonthProvider.notifier).state = currentMonth;
                    ref.read(selectedDayProvider.notifier).state =
                        DateTime(now.year, now.month, now.day);
                  },
            child: const Text('Today'),
          ),
        ],
      ),
    );
  }
}
