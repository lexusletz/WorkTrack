import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CalendarNavigation extends StatelessWidget {
  const CalendarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          children: [
            _buildArrowButton(context, LucideIcons.chevronLeft),
            Text(
              "Mayo", 
              style: TextStyle(color: colorScheme.onSurfaceVariant)
            ),
            _buildArrowButton(context, LucideIcons.chevronRight),
          ],
        ),

        TextButton(
          child: Text(
            "Hoy",
            style: TextStyle(color: colorScheme.primary),
          ),
          onPressed: () {
            // TODO: Implement this functionality
            // Change the selected month to the current month on date.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Feature not implemented!", 
                  style: TextStyle(color: Colors.white),
                )
              )
            );
          },
        ),
      ],
    );
  }

  Widget _buildArrowButton(BuildContext context, IconData icon) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // TODO: Implement this functionality
        // Change the selected month for the displayed grid

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Feature not implemented!", 
              style: TextStyle(color: Colors.white),
            )
          )
        );
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.primaryContainer
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}
