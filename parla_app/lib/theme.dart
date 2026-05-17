import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

const String kFontDisplay = 'Plus Jakarta Sans';
const String kFontBody = 'Inter';

// ── Re-exports (gaýry faýllaryň importy bozulmasyn) ──
const Color kPrimary        = AppColors.kPrimary;
const Color kPrimarySoft    = AppColors.kPrimarySoft;
const Color kSecondary      = AppColors.kSecondary;
const Color kAccentLight    = AppColors.kAccentLight;
const Color kStickerOutline = AppColors.kStickerOutline;
const Color kScaffoldBg     = AppColors.kScaffoldBg;
const Color kSurfaceBg      = AppColors.kSurfaceBg;
const Color kCardBg         = AppColors.kCardBg;
const Color kError          = AppColors.kError;
const Color kSuccess        = AppColors.kSuccess;
const Color kStar           = AppColors.kStar;
const Color kTeamSeeAll     = AppColors.kTeamSeeAll;
const Color kTeamRoleText   = AppColors.kTextTertiary;
const Color kTeamStar       = AppColors.kTeamStar;
const Color kTextPrimary    = AppColors.kTextPrimary;
const Color kTextSecondary  = AppColors.kTextSecondary;
const Color kTextTertiary   = AppColors.kTextTertiary;
const Color kBorder         = AppColors.kBorder;
const Color kBorderMedium   = AppColors.kBorderMedium;

// ── Shadows (re-exports) ──
List<BoxShadow> get kShadowSm      => AppColors.kShadowSm;
List<BoxShadow> get kShadowUpMd    => AppColors.kShadowUpMd;
List<BoxShadow> get kShadowDownSm  => AppColors.kShadowDownSm;
List<BoxShadow> get kShadowMd      => AppColors.kShadowMd;
List<BoxShadow> get kShadowPill    => AppColors.kShadowPill;
List<BoxShadow> get kShadowLg      => AppColors.kShadowLg;
List<BoxShadow> get kStickerShadow => AppColors.kStickerShadow;

const Color _buttonPrimaryColor = AppColors.kPrimary;

BoxDecoration kStickerCardDecoration({double radius = AppRadius.m}) => BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: kStickerOutline),
      boxShadow: kStickerShadow,
    );

// ── Page transition ──
Route<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0.04, 0), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

ThemeData buildParlaTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kPrimary,
    primary: kPrimary,
    secondary: kSecondary,
    brightness: Brightness.light,
    surface: kCardBg,
    error: kError,
    onSurface: kTextPrimary,
    onSurfaceVariant: kTextSecondary,
  );

  final textTheme = TextTheme(
    // H1 — Main title (Tartuffo, 32-40)
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 34,
      fontWeight: FontWeight.w600,
      height: 1.12,
      letterSpacing: -0.5,
      color: kTextPrimary,
    ),
    displayMedium: GoogleFonts.plusJakartaSans(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.14,
      letterSpacing: -0.35,
      color: kTextPrimary,
    ),
    displaySmall: GoogleFonts.plusJakartaSans(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.16,
      letterSpacing: -0.2,
      color: kTextPrimary,
    ),
    // H2 — Section title (Tartuffo, 24-28)
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      letterSpacing: -0.15,
      height: 1.22,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: kTextPrimary,
      letterSpacing: -0.1,
      height: 1.24,
    ),
    headlineSmall: GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      letterSpacing: -0.05,
      height: 1.26,
    ),
    // H3 — Subsection (Roobert, 18-22)
    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      height: 1.28,
      letterSpacing: -0.1,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: kTextPrimary,
      height: 1.3,
      letterSpacing: -0.05,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: kTextPrimary,
      height: 1.33,
    ),
    // Body (Roobert, 14-16)
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: kTextPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kTextSecondary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kTextSecondary,
      height: 1.45,
    ),
    // Buttons / labels
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: kTextPrimary,
      height: 1.25,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: kTextPrimary,
      height: 1.3,
      letterSpacing: 0.1,
    ),
    // Small / Caption (Roobert, 12)
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: kTextTertiary,
      height: 1.35,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: kScaffoldBg,
    dividerColor: kBorder,
    appBarTheme: AppBarTheme(
      backgroundColor: kScaffoldBg,
      foregroundColor: kTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      titleTextStyle: textTheme.headlineSmall,
      iconTheme: const IconThemeData(color: kTextPrimary, size: 24),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      backgroundColor: kCardBg,
      elevation: 8,
      shadowColor: Colors.black26,
      indicatorColor: kPrimary.withValues(alpha: 0.12),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kPrimary, size: 26);
        }
        return const IconThemeData(color: kTextSecondary, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kPrimary,
            height: 1.3,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: kTextSecondary,
          height: 1.3,
        );
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      elevation: 4,
    ),
    dividerTheme: const DividerThemeData(
      color: kBorder,
      thickness: 1,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _buttonPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kBorder),
        foregroundColor: kTextPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        textStyle: textTheme.labelMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _buttonPrimaryColor,
        textStyle: textTheme.labelMedium,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      color: kCardBg,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
      iconColor: kTextSecondary,
      textColor: kTextPrimary,
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: const BorderSide(color: kError, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: const BorderSide(color: kError, width: 2),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: const Color(0xFFC2C2C2),
        fontWeight: FontWeight.w400,
      ),
      labelStyle: textTheme.bodyMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 14),
    ),
  );
}
