import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Colors (Fresha style, cyan variant) ──
const Color kPrimary = Color(0xFF00ACC1);       // Fresha #7C40F6 → cyan
const Color kSecondary = Color(0xFF0097A7);      // goýuraq cyan
const Color kAccentLight = Color(0xFF26C6DA);    // açyk cyan
const Color kScaffoldBg = Color(0xFFFFFFFF);     // Fresha: ak fon
const Color kSurfaceBg = Color(0xFFF8F8F8);      // Fresha: çeýe fon
const Color kCardBg = Color(0xFFFFFFFF);         // karta fony
const Color kError = Color(0xFFE53935);
const Color kSuccess = Color(0xFF43A047);
const Color kStar = Color(0xFFFFB800);           // Fresha: reýting ýyldyzy
const Color kTextPrimary = Color(0xFF1C1C1C);    // Fresha: esasy tekst
const Color kTextSecondary = Color(0xFF757575);   // Fresha: ikinji tekst
const Color kTextTertiary = Color(0xFF9E9E9E);    // Fresha: üçünji tekst
const Color kBorder = Color(0xFFF0F0F0);          // Fresha: gyra/border
const Color kBorderMedium = Color(0xFFBDBDBD);     // Fresha: orta gyra

// ── Spacing scale ──
const double kSpaceXs = 4;
const double kSpaceSm = 8;
const double kSpaceMd = 12;
const double kSpaceLg = 16;
const double kSpaceXl = 20;
const double kSpace2xl = 24;
const double kSpace3xl = 32;

// ── Radius (Fresha: 12–14px tegelekler) ──
const double kRadiusSm = 8;
const double kRadiusMd = 12;
const double kRadiusLg = 14;
const double kRadiusXl = 20;
const double kRadiusPill = 24;

// ── Shadows ──
List<BoxShadow> kShadowSm = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 6,
    offset: const Offset(0, 1),
  ),
];

List<BoxShadow> kShadowMd = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
];

List<BoxShadow> kShadowLg = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    blurRadius: 20,
    offset: const Offset(0, 8),
  ),
];

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

  final baseTextStyle = TextStyle(
    fontFamilyFallback: const ['Roboto', 'sans-serif'],
  );

  // Fresha: aýdyň ierarhiýa, 20–24px sözbaşy, 15–16px atlar, 13px çal tekst
  final textTheme = GoogleFonts.interTextTheme().copyWith(
    headlineLarge: GoogleFonts.inter(
      fontSize: 26, fontWeight: FontWeight.w700,
      color: kTextPrimary, letterSpacing: -0.6, height: 1.22,
    ).merge(baseTextStyle),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22, fontWeight: FontWeight.w700,
      color: kTextPrimary, height: 1.25,
    ).merge(baseTextStyle),
    titleLarge: GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w700,
      color: kTextPrimary, height: 1.28,
    ).merge(baseTextStyle),
    titleMedium: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w600,
      color: kTextPrimary, height: 1.3,
    ).merge(baseTextStyle),
    titleSmall: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w600,
      color: kTextPrimary, height: 1.3,
    ).merge(baseTextStyle),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w400,
      color: kTextPrimary, height: 1.45,
    ).merge(baseTextStyle),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400,
      color: kTextSecondary, height: 1.45,
    ).merge(baseTextStyle),
    bodySmall: GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w400,
      color: kTextSecondary, height: 1.4,
    ).merge(baseTextStyle),
    labelLarge: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w600,
      color: kTextPrimary,
    ).merge(baseTextStyle),
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
      titleTextStyle: textTheme.titleLarge,
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
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kPrimary, fontFamilyFallback: ['Roboto']);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kTextSecondary, fontFamilyFallback: ['Roboto']);
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
      elevation: 4,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusLg)),
      color: kCardBg,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMd),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMd),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMd),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMd),
        borderSide: const BorderSide(color: kError, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMd),
        borderSide: const BorderSide(color: kError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: kSpaceLg, vertical: 14),
    ),
  );
}
