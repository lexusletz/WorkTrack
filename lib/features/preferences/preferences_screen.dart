import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/preferences_model.dart';
import '../../core/preferences/preferences_providers.dart';
import 'widgets/hourly_rate_section.dart';
import 'widgets/options_section.dart';
import 'widgets/preferences_header.dart';
import 'widgets/working_days_section.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  late Preferences _draft;

  @override
  void initState() {
    super.initState();

    _draft = ref.read(preferencesProvider).value ?? Preferences.defaults;
  }

  Future<void> _save() async {
    await ref.read(preferencesProvider.notifier).savePreferences(_draft);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      PreferencesHeader(),
                      SizedBox(height: 18),
                      HourlyRateSection(
                        value: _draft.hourlyRate,
                        onChange: (value) {
                          setState(() {
                            _draft = _draft.copyWith(hourlyRate: value);
                          });
                        },
                      ),
                      SizedBox(height: 18),
                      WorkingDaysSection(
                        selectedWorkingDays: _draft.workingDays,
                        onChange: (workingDays) {
                          setState(() {
                            _draft = _draft.copyWith(workingDays: workingDays);
                          });
                        },
                      ),
                      // SizedBox(height: 18),
                      // CurrencySymbolSection(),
                    ],
                  ),
                ),
              ),
              OptionsSection(onSave: _save),
            ],
          ),
        ),
      ),
    );
  }
}
