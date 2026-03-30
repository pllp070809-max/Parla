import 'package:flutter/material.dart';

import 'theme.dart';

/// Home and shared screen text tokens (sizes/weights) aligned with Parla fonts and colors.
class AppTextStyles {
  AppTextStyles._();

  static const _displayFallback = ['Times New Roman', 'serif'];
  static const _bodyFallback = ['Roboto', 'Arial', 'sans-serif'];

  static const TextStyle headerTitle = TextStyle(
    fontFamily: kFontDisplay,
    fontFamilyFallback: _displayFallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: kTextPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: kFontBody,
    fontFamilyFallback: _bodyFallback,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.28,
    letterSpacing: -0.08,
    color: kTextPrimary,
  );

  static const TextStyle sectionLink = TextStyle(
    fontFamily: kFontBody,
    fontFamilyFallback: _bodyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: kPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: kFontBody,
    fontFamilyFallback: _bodyFallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: kTextPrimary,
  );

  static const TextStyle cardMeta = TextStyle(
    fontFamily: kFontBody,
    fontFamilyFallback: _bodyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: kTextPrimary,
  );

  static const TextStyle categoryLabel = TextStyle(
    fontFamily: kFontBody,
    fontFamilyFallback: _bodyFallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: kTextPrimary,
  );
}
