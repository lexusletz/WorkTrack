import 'package:flutter/material.dart';

class PreferenceSection extends StatelessWidget {
  const PreferenceSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle = '',
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title, 
              style: const TextStyle(color: Color(0xFF9aa59e))
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Color(0xFF5c6b62)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        child,
      ],
    );
  }
}
