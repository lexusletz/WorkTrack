import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/updater/updater_providers.dart';

class AppFooter extends ConsumerWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.1),
          margin: const EdgeInsets.symmetric(horizontal: 18),
        ),
        const SizedBox(height: 14),
        Text(
          "MADE WITH ♥ BY JORDY PINOS",
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          "VERSION V${packageInfo.version}",
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
