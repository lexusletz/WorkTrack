import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HourlyRateField extends StatelessWidget {
  const HourlyRateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.currencySymbol = r'$',
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value > 0 ? value.toString() : '',
      decoration: InputDecoration(
        labelText: 'Hourly Rate',
        prefixText: '$currencySymbol ',
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (v) {
        final n = double.tryParse(v ?? '');
        if (n == null || n <= 0) return 'Enter a rate greater than 0';
        return null;
      },
      onChanged: (v) {
        final n = double.tryParse(v);
        if (n != null && n > 0) onChanged(n);
      },
    );
  }
}
