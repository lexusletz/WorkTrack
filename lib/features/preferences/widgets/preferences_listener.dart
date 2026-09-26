import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/preferences/domain/preferences_model.dart';
import '../../../core/preferences/providers/preferences_providers.dart';
import '../../../core/ui/custom_snackbar.dart';
import '../../../core/utils/globals.dart';

class PreferencesListener extends ConsumerWidget {
  final Widget child;

  const PreferencesListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CustomSnackbar snackbar = CustomSnackbar(
      text: "No se pudieron guardar las preferencias en el servidor",
      icon: LucideIcons.cloudOff,
    );

    ref.listen<AsyncValue<Preferences>>(preferencesProvider, ((previous, next) {
      if (next is AsyncError && !next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          scaffoldMessengerKey.currentState?.showSnackBar(
            snackbar.build(colorScheme),
            snackBarAnimationStyle: snackbar.animationStyle,
          );
        });
      }
    }));

    return child;
  }
}
