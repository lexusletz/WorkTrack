import 'package:flutter/material.dart';

import 'widgets/accumulated_section.dart';
import 'widgets/amounts_section.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/installation_time.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
              InstallationTime(),
            ],
          ),
        ),
      ),
    );
  }
}
