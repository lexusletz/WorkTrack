import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardHoursField extends StatelessWidget {
  const StandardHoursField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: const InputDecoration(
        labelText: 'Standard Hours / Day',
        suffixText: 'h',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (v) {
        final n = double.tryParse(v ?? '');
        if (n == null || n <= 0 || n > 24) return 'Enter hours between 0 and 24';
        return null;
      },
      onChanged: (v) {
        final n = double.tryParse(v);
        if (n != null && n > 0 && n <= 24) onChanged(n);
      },
    );
  }
}
