import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencySymbolField extends StatelessWidget {
  const CurrencySymbolField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Currency Symbol',
        hintText: r'$',
        border: OutlineInputBorder(),
      ),
      maxLength: 3,
      inputFormatters: [LengthLimitingTextInputFormatter(3)],
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter a currency symbol';
        return null;
      },
      onChanged: (v) {
        if (v.trim().isNotEmpty) onChanged(v.trim());
      },
    );
  }
}
