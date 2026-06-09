import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color brand50 = Color(0xFFFCF2F7);
  static const Color brand100 = Color(0xFFF8E0EC);
  static const Color brand200 = Color(0xFFF0C2D8);
  static const Color brand300 = Color(0xFFDFA0B9);
  static const Color brand400 = Color(0xFFBF6D95);
  static const Color brand500 = Color(0xFFA8527E); // Primary
  static const Color brand600 = Color(0xFF8E3D66);
  static const Color brand700 = Color(0xFF6F2B4F);
  static const Color brand800 = Color(0xFF4E1E37);
  static const Color brand900 = Color(0xFF2E1322);

  // Neutral Palette (Pink-tinted)
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFDF8F5); // Scaffold bg
  static const Color neutral100 = Color(0xFFF5EDF3);
  static const Color neutral200 = Color(0xFFE8D9E3);
  static const Color neutral300 = Color(0xFFC4AEBA);
  static const Color neutral400 = Color(0xFF9B8492);
  static const Color neutral500 = Color(0xFF6B5A65);
  static const Color neutral700 = Color(0xFF2E2028); // Text primary
  static const Color neutral900 = Color(0xFF1A1018); // Dark CTA

  // Semantic Palette
  // Success
  static const Color successSoft = Color(0xFFE3F0E5);
  static const Color successMain = Color(0xFF4A9447);
  static const Color successStrong = Color(0xFF2D6A35);
  
  // Warning
  static const Color warningSoft = Color(0xFFFBF0DC);
  static const Color warningMain = Color(0xFFC77A1A);
  static const Color warningStrong = Color(0xFF8E5510);
  
  // Error
  static const Color errorSoft = Color(0xFFFBE5EA);
  static const Color errorMain = Color(0xFFC93B52);
  static const Color errorStrong = Color(0xFF8E2840);

  // Info
  static const Color infoSoft = Color(0xFFDFE8F2);
  static const Color infoMain = Color(0xFF1A5FAD);
  static const Color infoStrong = Color(0xFF103E72);

  // Accents / Other
  static const Color starMain = Color(0xFFFFB800);
  static const Color starSoft = Color(0xFFFFF4D9);

  // Overlays
  static const Color overlayStrong = Color(0x992E2028); // 60% neutral-700
  static const Color overlayLight = Color(0x4D2E2028); // 30% neutral-700

  // Aliases (Light Theme Defaults)
  static const Color textPrimary = neutral700;
  static const Color textSecondary = neutral500;
  static const Color textTertiary = neutral400;
  static const Color textOnBrand = neutral0;
  static const Color textLink = brand600;

  static const Color bgScaffold = neutral50;
  static const Color bgCard = neutral0;
  static const Color bgSurface = neutral100;
  static const Color bgOverlay = overlayStrong;

  static const Color borderDefault = neutral200;
  static const Color borderStrong = neutral300;
  static const Color borderBrand = brand500;

  // Skeletons
  static const Color skeletonBase = neutral100;
  static const Color skeletonShine = neutral200;
}





