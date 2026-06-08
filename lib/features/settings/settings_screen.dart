import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_model.dart';
import '../../core/settings/settings_providers.dart';
import 'widgets/currency_symbol_section.dart';
import 'widgets/hourly_rate_section.dart';
import 'widgets/options_section.dart';
import 'widgets/settings_header.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  late Settings _draft;

  @override
  void initState() {
    super.initState();

    _draft = ref.read(settingsProvider).value ?? Settings.defaults;
  }

  Future<void> _save() async {
    await ref.read(settingsProvider.notifier).saveSettings(_draft);
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
                      SettingsHeader(),
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
                      CurrencySymbolSection(),
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
