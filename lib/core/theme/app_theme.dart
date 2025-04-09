// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC5);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);

  // For task status colors
  static const Color completedColor = Color(0xFF4CAF50);
  static const Color skippedColor = Color(0xFFFF9800);
  static const Color failedColor = Color(0xFFF44336);
  static const Color pendingColor = Color(0xFFBDBDBD);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onError: Colors.white,
        surface: cardColor,
        onSurface: textPrimaryColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textSecondaryColor,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}