import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF0D47A1); // BTG deep blue

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
    useMaterial3: true,
    cardTheme: const CardThemeData(elevation: 2),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    cardTheme: const CardThemeData(elevation: 2),
  );
}
