import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF0D47A1); // BTG deep blue

  static final lightColorScheme = ColorScheme.fromSeed(seedColor: _seed);

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  );

  static final light = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    cardTheme: CardThemeData(
      color: lightColorScheme.surfaceContainerLowest,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: lightColorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
    ),
  );

  static final dark = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    cardTheme: CardThemeData(
      color: darkColorScheme.surfaceContainerLow,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: darkColorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
    ),
  );
}
