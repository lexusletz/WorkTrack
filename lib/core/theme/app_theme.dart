import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ColorScheme _appColorScheme = ColorScheme.dark(
    surface: const Color(0xFF0e1411),
    surfaceContainerHighest: const Color(0xFF1F2C26),
    surfaceContainerLowest: const Color(0xFF16201b),
    outline: Colors.white.withValues(alpha: 0.06),

    onSurface: const Color(0xFF5c6b62),
    onSurfaceVariant: const Color(0xFF5C6B62),

    primary: const Color(0xFF7BD389),
    primaryContainer: const Color(0xFF1F2C26),
    error: const Color(0xFFFF6B5B),
    tertiary: const Color(0xFFE8B86C)
  );

  static ThemeData build(WidgetRef ref) {
    return ThemeData(
      colorScheme: _appColorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.geologicaTextTheme(),
    );
  }
}
