import 'package:flutter/material.dart';

class WorkingDaysSelector extends StatelessWidget {
  const WorkingDaysSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  static const _labels = {
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Working Days', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _labels.entries.map((e) {
            final isSelected = selected.contains(e.key);
            return FilterChip(
              label: Text(e.value),
              selected: isSelected,
              onSelected: (on) {
                final next = Set<int>.from(selected);
                if (on) {
                  next.add(e.key);
                } else if (next.length > 1) {
                  next.remove(e.key);
                }
                onChanged(next);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
