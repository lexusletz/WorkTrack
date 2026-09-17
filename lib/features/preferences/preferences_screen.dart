import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/domain/preferences_model.dart';
import '../../core/preferences/providers/preferences_providers.dart';
import '../../core/ui/scaffold/dismiss_keyboard_on_interaction.dart';
import 'widgets/app_footer.dart';
import 'widgets/currency_symbol_section.dart';
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
  late Preferences _prevPrefs, _draft;
  final _scrollController = ScrollController();
  double _headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _prevPrefs = ref.read(preferencesProvider).value ?? Preferences.defaults;
    _draft = _prevPrefs;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final opacity = (1 - (_scrollController.offset / 40)).clamp(0.0, 1.0);
    if (opacity != _headerOpacity) {
      setState(() => _headerOpacity = opacity);
    }
  }

  Future<void> _save() async {
    await ref.read(preferencesProvider.notifier).savePreferences(_draft);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: DismissKeyboardOnInteraction(
          child: Container(
            margin: const EdgeInsets.only(top: 14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Opacity(
                    opacity: _headerOpacity,
                    child: Column(
                      children: [PreferencesHeader(), SizedBox(height: 18)],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          HourlyRateSection(
                            value: _draft.hourlyRate,
                            symbol: _draft.currency,
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
                                _draft = _draft.copyWith(
                                  workingDays: workingDays,
                                );
                              });
                            },
                          ),
                          SizedBox(height: 18),
                          CurrencySymbolSection(
                            selectedSymbol: _draft.currency,
                            onChange: (symbol) {
                              setState(() {
                                _draft = _draft.copyWith(currency: symbol);
                              });
                            },
                          ),
                          SizedBox(height: 18),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                OptionsSection(onSave: _save, isActive: _draft != _prevPrefs),
                AppFooter(),
                // We use 20 so it gives time for the keyboard to remove the
                // bottom padding so it doesn't "jumps" when the keyboard is dismissed.
                // It just gives a better UX.
                if (MediaQuery.of(context).viewInsets.bottom >= 20)
                  SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
