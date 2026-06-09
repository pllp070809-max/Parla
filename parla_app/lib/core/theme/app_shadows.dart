import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> none = [];
  
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 3, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0F2E2028), blurRadius: 6, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 6, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x142E2028), blurRadius: 15, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> pill = [
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 6, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x1F2E2028), blurRadius: 15, offset: Offset(0, 10)),
  ];

  // Old legacy shadows for migration
  static const List<BoxShadow> kShadowSm = sm;
  static const List<BoxShadow> kShadowMd = md;
  static const List<BoxShadow> kShadowLg = lg;
  static const List<BoxShadow> kShadowPill = pill;
  static const List<BoxShadow> kShadowUpMd = [
    BoxShadow(color: Color(0x0A2E2028), blurRadius: 4, offset: Offset(0, -2)),
  ];
  static const List<BoxShadow> kStickerShadow = sm;
  static const List<BoxShadow> kShadowCircleBtn = pill;

  static BoxDecoration kStickerCardDecoration({double radius = 16.0}) => BoxDecoration(
        color: const Color(0xFFFFFFFF), // bgCard
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFC4AEBA)), // borderStrong
        boxShadow: kStickerShadow,
      );
}


