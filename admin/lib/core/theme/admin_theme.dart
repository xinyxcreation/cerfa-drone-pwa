import 'package:flutter/material.dart';

class AdminTheme {

  static ThemeData get theme {

    return ThemeData(
      useMaterial3: true,

      colorSchemeSeed:
          const Color(0xFFFF6600),

      scaffoldBackgroundColor:
          const Color(0xFFF5F6F8),

      inputDecorationTheme:
          const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),

      cardTheme:
          const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
      ),

      appBarTheme:
          const AppBarTheme(
        centerTitle: false,
      ),
    );

  }

}
