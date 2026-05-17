import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

/// Home and shared screen text tokens (sizes/weights) aligned with Parla fonts and colors.
class AppTextStyles {
  AppTextStyles._();

  static final TextStyle headerTitle = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: kTextPrimary,
  );

  static final TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.28,
    letterSpacing: -0.08,
    color: kTextPrimary,
  );

  static final TextStyle sectionLink = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: kPrimary,
  );

  static final TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: kTextPrimary,
  );

  static final TextStyle cardMeta = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: kTextPrimary,
  );

  static final TextStyle categoryLabel = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: kTextPrimary,
  );
}
