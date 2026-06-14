import 'package:flutter/material.dart';

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
    final Map<int, String> days = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 10),
        Row(
          spacing: 10,
          children: days.entries
              .map<Widget>(
                (day) => _buildButton(day.value, day.key, colorScheme),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("02 • WORKING DAYS", style: TextStyle(color: Color(0xFF9aa59e))),
        Text("WHICH DAYS YOU WORK", style: TextStyle(color: Color(0xFF5c6b62))),
      ],
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
