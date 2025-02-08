import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/gen/fonts.gen.dart';

abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFF065808),
        primaryContainer: Color(0xFF9EE2A0),
        primaryLightRef: Color(0xFF065808),
        secondary: Color(0xFF365B37),
        secondaryContainer: Color(0xFFAFBDAF),
        secondaryLightRef: Color(0xFF365B37),
        tertiary: Color(0xFF2C7E2E),
        tertiaryContainer: Color(0xFFB9E6B9),
        tertiaryLightRef: Color(0xFF2C7E2E),
        appBarColor: Color(0xFFB9E6B9),
        error: Color(0xFFB00020),
        errorContainer: Color(0xFFFCD9DF),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        useM2StyleDividerInM3: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
        navigationRailLabelType: NavigationRailLabelType.all,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      fontFamily: FontFamily.poppins);
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFF629F80),
        primaryContainer: Color(0xFF284134),
        primaryLightRef: Color(0xFF065808),
        secondary: Color(0xFF81B39A),
        secondaryContainer: Color(0xFF4D6B5C),
        secondaryLightRef: Color(0xFF365B37),
        tertiary: Color(0xFF88C5A6),
        tertiaryContainer: Color(0xFF356C51),
        tertiaryLightRef: Color(0xFF2C7E2E),
        appBarColor: Color(0xFF356C51),
        error: Color(0xFFCF6679),
        errorContainer: Color(0xFFB1384E),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
        navigationRailLabelType: NavigationRailLabelType.all,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      fontFamily: FontFamily.poppins);
}
