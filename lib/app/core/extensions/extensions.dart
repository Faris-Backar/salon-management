import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  // Access the entire ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  // Access specific colors from the ColorScheme
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get surfaceColor => colorScheme.surface;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get onBackgroundColor => colorScheme.onSurface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get errorColor => colorScheme.error;
}

extension DefaultScreenPadding on BuildContext {
  EdgeInsets get defaultScreenPadding => const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      );
}
