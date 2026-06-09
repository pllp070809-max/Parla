import 'package:flutter/material.dart';

class AppTypography {
  static const String _fraunces = 'Fraunces';
  static const String _plusJakarta = 'Plus Jakarta Sans';

  // display: 32px, 400 italic, 1.1 LH, -2% LS
  static TextStyle get display => const TextStyle(
        fontFamily: _fraunces,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.1,
        letterSpacing: 32 * -0.02,
      );

  // title: 24px, 500, 1.2 LH, -1% LS
  static TextStyle get title => const TextStyle(
        fontFamily: _plusJakarta,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 24 * -0.01,
      );

  // headline: 17px, 600, 1.4 LH, -0.3% LS
  static TextStyle get headline => const TextStyle(
        fontFamily: _plusJakarta,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 17 * -0.003,
      );

  // body: 15px, 400, 1.5 LH, 0 LS
  static TextStyle get body => const TextStyle(
        fontFamily: _plusJakarta,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
      );

  // caption: 13px, 400, 1.45 LH, 0 LS
  static TextStyle get caption => const TextStyle(
        fontFamily: _plusJakarta,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
      );

  // micro: 11px, 500, 1.3 LH, +8% LS
  static TextStyle get micro => const TextStyle(
        fontFamily: _plusJakarta,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 11 * 0.08,
      );
}





