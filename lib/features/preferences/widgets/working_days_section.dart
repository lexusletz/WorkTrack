import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'preference_section.dart';

class WorkingDaysSection extends StatelessWidget {
  const WorkingDaysSection({
    super.key,
    required this.selectedWorkingDays,
    required this.onChange,
  });

  final List<int> selectedWorkingDays;
  final Function(List<int>) onChange;

  bool isDaySelected(int day) => selectedWorkingDays.contains(day);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final Map<int, String> days = {
      1: l10n.monShort,
      2: l10n.tueShort,
      3: l10n.wedShort,
      4: l10n.thuShort,
      5: l10n.friShort,
      6: l10n.satShort,
      7: l10n.sunShort,
    };

    return PreferenceSection(
      title: l10n.sectionWorkingDaysTitle,
      subtitle: l10n.sectionWorkingDaysSubtitle,
      child: Row(
        spacing: 10,
        children: days.entries
            .map<Widget>(
              (day) => _buildButton(day.value, day.key, colorScheme),
            )
            .toList(),
      ),
    );
  }

  Widget _buildButton(String day, int value, ColorScheme colorScheme) {
    final isSelected = isDaySelected(value);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final List<int> localList = List.from(selectedWorkingDays);

          if (!selectedWorkingDays.contains(value)) {
            localList.add(value);
          } else {
            localList.remove(value);
          }

          onChange(localList);
        },
        child: AspectRatio(
          aspectRatio: 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
