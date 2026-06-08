import 'package:flutter/material.dart';
import '../../../core/worklog/worklog_model.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.status,
    required this.isSelected,
    required this.isToday,
    required this.hoursWorked,
    required this.onTap,
  });

  final int day;
  final DayStatus status;
  final bool isSelected;
  final bool isToday;
  final double? hoursWorked;
  final VoidCallback onTap;

  static final _statusColors = {
    DayStatus.WORKDAY: const Color(0xFF16201b),
    DayStatus.NONWORKDAY: Colors.transparent,
  };

  static final _textColors = {
    DayStatus.WORKDAY: const Color(0xFF9aa59e),
    DayStatus.NONWORKDAY: const Color(0xFF5c6b62),
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : isToday
              ? Border.all(color: colorScheme.primary.withAlpha(100), width: 1)
              : null,
          color: _statusColors[status],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: _textColors[status],
                  fontSize: 12,
                ),
              ),
              Spacer(),
              if (hoursWorked != null && hoursWorked != null && hoursWorked! > 0)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7bd389),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
