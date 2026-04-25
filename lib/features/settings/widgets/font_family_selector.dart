import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_track/core/extensions/string_extension.dart';
import 'package:work_track/core/theme/typography.dart';

class FontFamilySelector extends ConsumerWidget {
  const FontFamilySelector({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final FontFamilyOptions value;
  final Function(FontFamilyOptions) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<FontFamilyOptions>(
      initialValue: value,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      items: FontFamilyOptions.values.map((option) {
        return DropdownMenuItem<FontFamilyOptions>(
          value: option,
          child: Text(option.name.capitalize()),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
    );
  }
}
