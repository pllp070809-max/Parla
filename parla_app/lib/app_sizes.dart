import 'app_radius.dart';
import 'app_spacing.dart';

/// Layout tokens for screens (aligned with design spec; `screenWidth` excluded).
class AppSizes {
  AppSizes._();

  static const double paddingHorizontal = AppSpacing.screenPadding;
  static const double sectionSpacing = AppSpacing.xl;
  static const double elementSpacing = AppSpacing.m;
  static const double smallSpacing = AppSpacing.s;

  static const double radiusMd = AppRadius.m;
  static const double radiusLg = AppRadius.m;

  static const double headerHeight = 72;
  static const double bottomNavHeight = 64;

  static const double cardWidth = 260;
  static const double cardImageHeight = 140;
  static const double exploreCardHeight = 100;

  /// Category circle diameter (tap target).
  static const double categorySize = 72;

  /// Min width for category column (label under circle).
  static const double categoryColumnWidth = 88;
}
