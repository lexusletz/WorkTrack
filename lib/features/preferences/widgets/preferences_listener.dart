import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/preferences/domain/preferences_model.dart';
import '../../../core/preferences/providers/preferences_providers.dart';
import '../../../core/utils/globals.dart';

class PreferencesListener extends ConsumerWidget {
  final Widget child;

  const PreferencesListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<Preferences>>(preferencesProvider, ((previous, next) {
      if (next is AsyncError && !next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(LucideIcons.cloudOff, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Couldn't save preferences in the server.", 
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                ],
              ),
              backgroundColor: colorScheme.primaryContainer,
              duration: const Duration(seconds: 4),
            ),
            snackBarAnimationStyle: AnimationStyle(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
            )
          );
        });
      }
    }));

    return child;
  }
}
