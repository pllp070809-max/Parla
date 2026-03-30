import 'package:flutter/material.dart';

import 'app_radius.dart';
import 'app_spacing.dart';

const String kFontDisplay = 'Tartuffo';
const String kFontBody = 'Roobert';

// ── Colors (Fresha style, cyan variant) ──
const Color kPrimary = Color(0xFF00ACC1);       // Fresha #7C40F6 → cyan
const Color kPrimarySoft = Color(0xFFE8F8FA); // saýlanan kartlar üçin ýeňil cyan fon
const Color kSecondary = Color(0xFF0097A7);      // goýuraq cyan
const Color kAccentLight = Color(0xFF26C6DA);    // açyk cyan
const Color kScaffoldBg = Color(0xFFFFFFFF);     // Fresha: ak fon
const Color kSurfaceBg = Color(0xFFFAFAFA);      // Fresha: çeýe fon
const Color kCardBg = Color(0xFFFFFFFF);         // karta fony
const Color kError = Color(0xFFE53935);
const Color kSuccess = Color(0xFF43A047);
const Color kStar = Color(0xFFFFB800);           // Fresha: reýting ýyldyzy
const Color kTeamSeeAll = Color(0xFF7B61FF);
const Color kTeamRoleText = Color(0xFF8E8E93);
const Color kTeamStar = Color(0xFFFFCC00);
const Color kTextPrimary = Color(0xFF18181B);    // Fresha: esasy tekst
const Color kTextSecondary = Color(0xFF71717A);   // Fresha: ikinji tekst
const Color kTextTertiary = Color(0xFFA1A1AA);    // Fresha: üçünji tekst
const Color kBorder = Color(0xFFE5E7EB);          // Fresha: gyra/border
const Color kBorderMedium = Color(0xFFBDBDBD);     // Fresha: orta gyra

// ── Shadows ──
List<BoxShadow> kShadowSm = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.03),
    blurRadius: 5,
    offset: const Offset(0, 1),
  ),
];

// Fresha stili: aşak panel / ýokarky panel köleleri.
List<BoxShadow> kShadowUpMd = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.045),
    blurRadius: 10,
    offset: const Offset(0, -4),
  ),
];

List<BoxShadow> kShadowDownSm = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 8,
    offset: const Offset(0, 4),
  ),
];

List<BoxShadow> kShadowMd = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.045),
    blurRadius: 10,
    offset: const Offset(0, 3),
  ),
];

List<BoxShadow> kShadowPill = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 10,
    offset: const Offset(0, 4),
  ),
];

List<BoxShadow> kShadowLg = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

// ── Stiker-stil tokens ──
// Subtle cyan-tinted border for sticker cards (matches kPrimary family)
const Color kStickerOutline = Color(0xFFD9F2F5);

// Two-layer shadow: faint cyan tint + soft black — gives depth without heaviness
List<BoxShadow> kStickerShadow = [
  BoxShadow(
    color: Color(0x1000ACC1), // kPrimary ~6%
    blurRadius: 16,
    offset: Offset(0, 5),
  ),
  BoxShadow(
    color: Color(0x08000000), // black ~3%
    blurRadius: 6,
    offset: Offset(0, 1),
  ),
];

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

  const displayFallback = ['Times New Roman', 'serif'];
  const bodyFallback = ['Roboto', 'Arial', 'sans-serif'];

  final textTheme = const TextTheme(
    // H1 — Main title (Tartuffo, 32-40)
    displayLarge: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 34,
      fontWeight: FontWeight.w600,
      height: 1.12,
      letterSpacing: -0.5,
      color: kTextPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.14,
      letterSpacing: -0.35,
      color: kTextPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.16,
      letterSpacing: -0.2,
      color: kTextPrimary,
    ),
    // H2 — Section title (Tartuffo, 24-28)
    headlineLarge: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      letterSpacing: -0.15,
      height: 1.22,
    ),
    headlineMedium: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      letterSpacing: -0.1,
      height: 1.24,
    ),
    headlineSmall: TextStyle(
      fontFamily: kFontDisplay,
      fontFamilyFallback: displayFallback,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      letterSpacing: -0.05,
      height: 1.26,
    ),
    // H3 — Subsection (Roobert, 18-22)
    titleLarge: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      height: 1.28,
      letterSpacing: -0.1,
    ),
    titleMedium: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      height: 1.3,
      letterSpacing: -0.05,
    ),
    titleSmall: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: kTextPrimary,
      height: 1.33,
    ),
    // Body (Roobert, 14-16)
    bodyLarge: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: kTextPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: kTextSecondary,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kTextSecondary,
      height: 1.45,
    ),
    // Buttons / labels
    labelLarge: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kTextPrimary,
      height: 1.25,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: kTextPrimary,
      height: 1.3,
      letterSpacing: 0.1,
    ),
    // Small / Caption (Roobert, 12)
    labelSmall: TextStyle(
      fontFamily: kFontBody,
      fontFamilyFallback: bodyFallback,
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
          return const TextStyle(
            fontFamily: kFontBody,
            fontFamilyFallback: bodyFallback,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kPrimary,
            height: 1.3,
          );
        }
        return const TextStyle(
          fontFamily: kFontBody,
          fontFamilyFallback: bodyFallback,
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
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
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
        foregroundColor: kPrimary,
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
