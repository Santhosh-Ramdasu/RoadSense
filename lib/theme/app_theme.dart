import 'package:flutter/material.dart';

class AppTheme {
  // === Color Palette ===
  static const Color primary = Color(0xFF4F46E5);       // Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF8B5CF6);     // Purple
  static const Color accent = Color(0xFF06B6D4);        // Cyan
  static const Color success = Color(0xFF10B981);       // Emerald
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color danger = Color(0xFFEF4444);        // Crimson
  static const Color critical = Color(0xFFDC2626);

  // Dark theme colors
  static const Color bgDark = Color(0xFF0A0E1A);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color borderDark = Color(0xFF374151);
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);

  // Light theme colors
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // Severity colors
  static Color severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return danger;
      case 'high': return Color(0xFFF97316);
      case 'medium': return warning;
      case 'low': return success;
      default: return primary;
    }
  }

  // Status colors
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved': return success;
      case 'in progress': return primary;
      case 'assigned': return warning;
      case 'pending': return danger;
      default: return textSecondary;
    }
  }

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6)],
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0E1A), Color(0xFF111827)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // === Dark Theme ===
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surfaceDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      error: danger,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderDark.withValues(alpha: 0.5)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      hintStyle: TextStyle(color: textSecondary),
      labelStyle: TextStyle(color: textSecondary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerColor: borderDark,
    iconTheme: const IconThemeData(color: textSecondary),
  );

  // === Light Theme ===
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surfaceLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
      error: danger,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimaryLight, letterSpacing: -0.5),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimaryLight),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimaryLight),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryLight),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimaryLight),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimaryLight),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textPrimaryLight),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondaryLight),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textSecondaryLight),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimaryLight),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderDark.withValues(alpha: 0.1)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimaryLight),
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderDark.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderDark.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      hintStyle: TextStyle(color: textSecondaryLight),
      labelStyle: TextStyle(color: textSecondaryLight),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primary,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerColor: borderDark.withValues(alpha: 0.2),
    iconTheme: const IconThemeData(color: textSecondaryLight),
  );
}
