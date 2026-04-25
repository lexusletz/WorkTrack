import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_track/core/settings/settings_providers.dart';

final textThemeProvider = Provider<TextTheme>((ref) {
  final settings = ref.watch(settingsProvider);
  final fontFamily =
      settings.value?.fontFamily ?? FontFamilyOptions.merriweather;

  return switch (fontFamily) {
    FontFamilyOptions.merriweather => GoogleFonts.merriweatherTextTheme(),
    FontFamilyOptions.nunito => GoogleFonts.nunitoTextTheme(),
    FontFamilyOptions.inter => GoogleFonts.interTextTheme(),
    FontFamilyOptions.montserrat => GoogleFonts.montserratTextTheme(),
    FontFamilyOptions.poppins => GoogleFonts.poppinsTextTheme(),
    FontFamilyOptions.rubik => GoogleFonts.rubikTextTheme(),
    FontFamilyOptions.workSans => GoogleFonts.workSansTextTheme(),
    FontFamilyOptions.manrope => GoogleFonts.manropeTextTheme(),
  };
});

enum FontFamilyOptions {
  merriweather,
  nunito,
  inter,
  montserrat,
  poppins,
  rubik,
  workSans,
  manrope,
}
