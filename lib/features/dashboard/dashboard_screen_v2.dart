import 'package:flutter/material.dart';

import 'widgets/accumulated_section.dart';
import 'widgets/amounts_section.dart';
import 'widgets/bottom_info.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/dashboard_header.dart';

class DashboardScreenV2 extends StatelessWidget {
  const DashboardScreenV2({super.key});

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
              SizedBox(height: 25),
              AccumulatedSection(),
              // TODO: Implement shift functionality and uncomment
              // SizedBox(height: 18),
              // ShiftSection(),
              SizedBox(height: 10),
              AmountsSection(),
              Expanded(child: CalendarGrid()),
              BottomInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
