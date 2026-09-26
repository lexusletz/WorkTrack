import 'package:flutter/material.dart';

/// Builds and displays a themed snackbar with optional leading icon.
///
/// The [CustomSnackbar] class provides a convenient way to create and show
/// snackbars with a consistent style throughout the application.
///
/// Use `showSnackbar(context)` to display the snackbar in the current context;
/// use `build(colorScheme)` to get the snackbar widget for custom display.
class CustomSnackbar {
  CustomSnackbar({required this.text, this.icon});

  /// The message displayed in the snackbar.
  final String text;

  /// An optional leading icon displayed before the text.
  final IconData? icon;

  /// Builds the snackbar using the provided [colorScheme].
  ///
  /// The snackbar is displayed for four seconds and uses the primary
  /// container color as its background.
  SnackBar build(ColorScheme colorScheme) {
    return SnackBar(
      content: Row(
        children: [
          icon != null ? Icon(icon, color: Colors.white) : SizedBox.shrink(),
          icon != null ? SizedBox(width: 10) : SizedBox.shrink(),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: colorScheme.primaryContainer,
      duration: const Duration(seconds: 4),
    );
  }

  /// The animation style used when showing the snackbar.
  AnimationStyle get animationStyle => AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.fastOutSlowIn,
  );

  /// Displays the snackbar using the nearest [ScaffoldMessenger].
  void showSnackbar(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(build(colorScheme), snackBarAnimationStyle: animationStyle);
  }
}
