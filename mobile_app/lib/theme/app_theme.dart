import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0284C7);
  static const primaryLight = Color(0xFFE0F2FE);
  static const accentOrange = Color(0xFFF97316);
  static const accentYellow = Color(0xFFFACC15);
  static const bg = Color(0xFFF8FAFC);
  static const text = Color(0xFF1E293B);
  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
