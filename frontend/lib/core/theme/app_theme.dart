import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color red =
  Color(0xFFE30613);

  static const Color dark =
  Color(0xFF111111);

  static ThemeData light() {
    final colorScheme =
    ColorScheme.fromSeed(
      seedColor: red,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme.copyWith(
        primary: red,
        secondary: red,
      ),

      scaffoldBackgroundColor:
      const Color(0xFFF5F5F5),

      appBarTheme: const AppBarTheme(
        backgroundColor: dark,
        foregroundColor: Colors.white,
          elevation: 0,
      ),

      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
            Radius.circular(18),
          ),
        ),
      ),

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: red,
            width: 2,
          ),
        ),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      elevatedButtonTheme:
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,

            minimumSize:
            const Size.fromHeight(52),

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(14),
            ),
        ),
      ),
    );
  }
}
