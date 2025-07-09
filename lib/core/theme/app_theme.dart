import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.black45,
    colorScheme: const ColorScheme.dark(
      primary: Colors.yellow,
      secondary: Colors.white,
      background: Colors.black87,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
    ),
  );
}
