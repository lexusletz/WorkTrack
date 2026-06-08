import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/settings/settings_providers.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/worklog/worklog_model.dart';
import '../../../core/worklog/worklog_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../state/dashboard_providers.dart';
import 'custom_divider.dart';
import 'hour_field.dart';
import 'text_number_animation.dart';

class DayEditorPanel extends ConsumerStatefulWidget {
  const DayEditorPanel({super.key});

  @override
  ConsumerState<DayEditorPanel> createState() => _DayEditorPanelState();
}

class _DayEditorPanelState extends ConsumerState<DayEditorPanel> {
  bool _initialized = false;
  double _hours = 0;

  Future<void> _save(DateTime day) async {
    final repo = ref.read(worklogRepositoryProvider);
    if (_hours == 0) {
      await repo.delete(day);
    } else {
      await repo.put(WorkLog(date: day, hoursWorked: _hours));
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialHours());
  }

  void _loadInitialHours() {
    if (!mounted || _initialized) return;
    final selectedDay = ref.read(selectedDayProvider);
    if (selectedDay == null) return;

    final settings = ref.read(settingsProvider);
    final month = DateTime(selectedDay.year, selectedDay.month);
    final logsAsync = ref.read(worklogsForMonthProvider(month));

    if (!settings.hasValue || !logsAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialHours());
      return;
    }

    final log = logsAsync.value!.cast<WorkLog?>().firstWhere(
      (l) => l?.key == WorkLog.keyFor(selectedDay),
      orElse: () => null,
    );

    setState(() {
      _initialized = true;
      _hours = log?.hoursWorked ?? settings.value!.standardHoursPerDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final symbol = settingsAsync.value?.currencySymbol ?? r'$';
    final hourPrice = settingsAsync.value?.hourlyRate ?? 0.0;

    if (selectedDay == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            AppLocalizations.of(context)!.selectADayLabel,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final equivalence = _hours * hourPrice;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF0e1411),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppDateUtils.getFormattedDate(selectedDay),
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
              Text(
                "EDIT",
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          HourField(
            value: _hours,
            onChange: (value) {
              setState(() {
                _hours = value;
              });
            },
          ),
          CustomDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "EQUIV",
                style: TextStyle(
                  color: const Color(0xFF9aa59e),
                ),
              ),
              TextNumberAnimation(
                duration: Duration(milliseconds: 800),
                value: equivalence,
                currencySymbol: symbol,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary
                ),
                decimals: 2,
                curve: Curves.easeOutCubic,
              )
            ],
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              _save(selectedDay);
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "CONFIRM",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          if (Platform.isIOS)
            SizedBox(height: 20),
        ],
      ),
    );
  }
}
