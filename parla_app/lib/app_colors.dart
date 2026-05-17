import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ──────────────────────────────────────────────────
  static const Color kPrimary        = Color(0xFFA8527E);
  static const Color kSecondary      = Color(0xFF8E3D66);
  static const Color kAccentLight    = Color(0xFFBF6D95);
  static const Color kPrimarySoft    = Color(0xFFFCF2F7);
  static const Color kStickerOutline = Color(0xFFF5DDE9);

  // ── Buttonlar ──────────────────────────────────────────────
  static const Color kDarkButton = Color(0xFF1A1018);

  // ── Tekst ──────────────────────────────────────────────────
  static const Color kTextPrimary   = Color(0xFF2E2028);
  static const Color kTextSecondary = Color(0xFF6B5A65);
  static const Color kTextTertiary  = Color(0xFF9B8492);
  static const Color kInputHint     = Color(0xFF9B8492);

  // ── Fon / Surface ──────────────────────────────────────────
  static const Color kScaffoldBg = Color(0xFFFDF8F5);
  static const Color kCardBg     = Color(0xFFFFFFFF);
  static const Color kSurfaceBg  = Color(0xFFF5EDF3);

  // ── Border / Divider ───────────────────────────────────────
  static const Color kBorder       = Color(0xFFE8D9E3);
  static const Color kBorderMedium = Color(0xFFC4AEBA);
  static const Color kDivider      = Color(0xFFF5EDF3);

  // ── Ýörite elementler ──────────────────────────────────────
  static const Color kStar      = Color(0xFFFFB800);
  static const Color kTeamStar  = Color(0xFFFFCC00);
  static const Color kTeamSeeAll = Color(0xFF6F5CC2);

  // ── Chip reňkleri ──────────────────────────────────────────
  static const Color kChipLavenderBg = Color(0xFFF2EDFF);
  static const Color kChipLavenderFg = Color(0xFF6F5CC2);
  static const Color kChipMintBg     = Color(0xFFEEF8ED);
  static const Color kChipMintFg     = Color(0xFF4A9447);

  // ── Semantic ───────────────────────────────────────────────
  static const Color kError   = Color(0xFFC93B52);
  static const Color kSuccess = Color(0xFF4A9447);

  // ── Shadows ────────────────────────────────────────────────
  static List<BoxShadow> get kShadowSm => [
    const BoxShadow(color: Color(0x081A1018), blurRadius: 5, offset: Offset(0, 1)),
  ];

  static List<BoxShadow> get kShadowUpMd => [
    const BoxShadow(color: Color(0x0B1A1018), blurRadius: 10, offset: Offset(0, -4)),
  ];

  static List<BoxShadow> get kShadowDownSm => [
    const BoxShadow(color: Color(0x0A1A1018), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static List<BoxShadow> get kShadowMd => [
    const BoxShadow(color: Color(0x0B1A1018), blurRadius: 10, offset: Offset(0, 3)),
  ];

  static List<BoxShadow> get kShadowPill => [
    const BoxShadow(color: Color(0x0F1A1018), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static List<BoxShadow> get kShadowLg => [
    const BoxShadow(color: Color(0x0F1A1018), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static List<BoxShadow> get kStickerShadow => [
    const BoxShadow(color: Color(0x10A8527E), blurRadius: 16, offset: Offset(0, 5)),
    const BoxShadow(color: Color(0x081A1018), blurRadius: 6, offset: Offset(0, 1)),
  ];

  static List<BoxShadow> get kShadowCircleBtn => const [
    BoxShadow(color: Color(0x141A1018), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
