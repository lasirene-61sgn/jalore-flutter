import 'package:flutter/material.dart';

class AppTheme {
  // Color Scheme from New Logo
  static const Color primaryBlue = Color(0xFF1E90FF); // DodgerBlue from logo (Main)
  static const Color secondaryBlue = Color(0xFF4DA6FF); // Lighter DodgerBlue
  static const Color darkBlue = Color(0xFF1873CC); // Darker DodgerBlue
  static const Color accentOrange = Color(0xFFFF8C00); // DarkOrange from logo background
  static const Color lightOrange = Color(0xFFFFA733); // Light Orange Accent
  static const Color gradientStart = Color(0xFF4DA6FF); // Blue Gradient Start
  static const Color gradientEnd = Color(0xFF1E90FF); // Blue Gradient End
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure White
  static const Color backgroundGrey = Color(0xFFF5F7FA); // Light Blue-Grey Tint
  static const Color textDark = Color(0xFF212121); // Dark Text
  static const Color textGrey = Color(0xFF757575); // Grey Text
  static const Color dividerGrey = Color(0xFFE3E8EF); // Light Blue-Grey Divider
  static const Color ssjsSecondaryBlue = Color(0xFFA4BBE7); // Light Blue-Grey Divider
  static const Color ssjsPrimaryBlue = Color(0xFF284A8A); // Light Blue-Grey Divider

  // Legacy color aliases for backward compatibility
  static const Color primaryOrange = accentOrange;
  static const Color secondaryOrange = lightOrange;
  static const Color darkOrange = accentOrange;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentOrange,
        surface: backgroundWhite,
        error: Color(0xFFD32F2F),
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: backgroundWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: backgroundWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: backgroundWhite,
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: dividerGrey,
        thickness: 1,
        space: 1,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textGrey,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
