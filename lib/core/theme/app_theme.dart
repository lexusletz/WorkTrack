import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_track/core/theme/typography.dart';

class AppTheme {
  static ThemeData build(WidgetRef ref) {
    final textTheme = ref.watch(textThemeProvider);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A237E),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: textTheme,
    );
  }
}
