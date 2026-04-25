import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_track/core/extensions/string_extension.dart';
import 'package:work_track/core/theme/typography.dart';

import '../../../core/settings/settings_providers.dart';

class FontFamilySelector extends ConsumerWidget {
  const FontFamilySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).requireValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font Family', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<FontFamilyOptions>(
          initialValue: settings.fontFamily,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: FontFamilyOptions.values.map((option) {
            return DropdownMenuItem<FontFamilyOptions>(
              value: option,
              child: Text(option.name.capitalize()),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              ref
                  .read(settingsProvider.notifier)
                  .saveSettings(settings.copyWith(fontFamily: v));
            }
          },
        ),
      ],
    );
  }
}
