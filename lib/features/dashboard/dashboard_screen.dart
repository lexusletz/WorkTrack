import 'package:flutter/material.dart';

import 'widgets/accumulated_section.dart';
import 'widgets/amounts_section.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              AccumulatedSection(),
              SizedBox(height: 10),
              AmountsSection(),
              Expanded(child: CalendarGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
