import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
export 'app_colors.dart';
export 'app_typography.dart';
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_shadows.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgScaffold,
      primaryColor: AppColors.brand500,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brand500,
        secondary: AppColors.brand400,
        surface: AppColors.bgCard,
        error: AppColors.errorMain,
        onPrimary: AppColors.textOnBrand,
        onSecondary: AppColors.textOnBrand,
        onSurface: AppColors.textPrimary,
        onError: AppColors.neutral0,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.display,
        titleLarge: AppTypography.title,
        titleMedium: AppTypography.headline,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.caption,
        labelSmall: AppTypography.micro,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgScaffold,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.title.copyWith(fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand500,
          foregroundColor: AppColors.textOnBrand,
          elevation: 0,
          textStyle: AppTypography.headline,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCard,
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brand500, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorMain, width: 1),
        ),
      ),
    );
  }
}






