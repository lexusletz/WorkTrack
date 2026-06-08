import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calendar_navigation.dart';
import 'day_editor_panel.dart';
import '../../../core/forecast/forecast_providers.dart';
import '../../../core/settings/settings_providers.dart';
import '../../../core/worklog/worklog_model.dart';
import '../../../core/worklog/worklog_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../state/dashboard_providers.dart';
import 'day_cell.dart';

class CalendarGrid extends ConsumerWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browsedMonth = ref.watch(browsedMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final logsAsync = ref.watch(worklogsForMonthProvider(browsedMonth));
    final now = ref.read(nowProvider);
    final today = DateTime(now.year, now.month, now.day);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final weekdayHeaders = [
      l10n.monShort,
      l10n.tueShort,
      l10n.wedShort,
      l10n.thuShort,
      l10n.friShort,
      l10n.satShort,
      l10n.sunShort,
    ];

    final settings = settingsAsync.value;
    final logMap = <String, WorkLog>{
      for (final l in logsAsync.value ?? []) l.key: l,
    };

    final daysInMonth = DateUtils.getDaysInMonth(
      browsedMonth.year,
      browsedMonth.month,
    );
    final firstWeekday = DateTime(
      browsedMonth.year,
      browsedMonth.month,
      1,
    ).weekday;
    final leadingBlanks = firstWeekday - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarNavigation(),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: weekdayHeaders
                .map(
                  (h) => Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // TODO: Improve this functionality
        // Add a `PageView` to change the month horizontally, updating the 
        // values of the `Forecast`
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // The number of days in a week
              childAspectRatio: 1.15,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (_, i) {
              if (i < leadingBlanks) return const SizedBox.shrink();

              final dayNum = i - leadingBlanks + 1;

              final date = DateTime(
                browsedMonth.year,
                browsedMonth.month,
                dayNum,
              );

              final log = logMap[WorkLog.keyFor(date)];
              final status = settings != null
                  ? dayStatusFor(date, log, settings)
                  : DayStatus.NONWORKDAY;
              final isSelected =
                  selectedDay != null &&
                  selectedDay.year == date.year &&
                  selectedDay.month == date.month &&
                  selectedDay.day == date.day;
              final isToday = date == today;

              return DayCell(
                day: dayNum,
                status: status,
                isSelected: isSelected,
                isToday: isToday,
                hoursWorked: log?.hoursWorked,
                onTap: () {
                  ref.read(selectedDayProvider.notifier).state = date;
                  if (MediaQuery.of(context).size.width < 600) {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isDismissible: true,
                      backgroundColor: const Color(0xFF16201b),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      builder: (_) => DayEditorPanel(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
