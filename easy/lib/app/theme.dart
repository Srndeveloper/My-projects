import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Delius',
      scaffoldBackgroundColor: Colors.white,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Color(0xFF93C5FD),
          iconSize: 35,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        secondary: Color(0xFF93C5FD),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF00008B),
        error: Color(0xFFF87171),
        tertiary: Color(0xFF111827),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Delius',
      scaffoldBackgroundColor: const Color(0xFF121212),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Color(0xFF60A5FA),
          iconSize: 35,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Color(0xFF60A5FA),
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white70,
        error: Color(0xFFF87171),
        tertiary: Color(0xFFD1D5DB),
      ),
    );
  }
}
