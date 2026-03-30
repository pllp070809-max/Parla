import 'package:flutter/material.dart';

/// Corner radii and reusable [BorderRadius] tokens.
class AppRadius {
  AppRadius._();

  static const double s = 8.0;
  static const double m = 12.0;
  static const BorderRadius card = BorderRadius.all(Radius.circular(12.0));
  static const double circle = 50.0;

  /// Bottom bar, chips, pill-shaped controls.
  static const double pill = 24.0;
}
