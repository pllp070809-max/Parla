/// Horizontal and vertical spacing scale for Parla UI.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  // --- KÖNE WE ÝALŇYŞ ÖLÇEGLER (Täze kodlarda ulanmaň) ---
  @Deprecated('Ulanmaň: Bu ölçeg 16.0 bellenen. Ýerine "large" ulanyň.')
  static const double l = 16.0;
  
  @Deprecated('Ulanmaň: Bu ölçeg 16.0 bellenen. Ýerine "extraLarge" ulanyň.')
  static const double xl = 16.0;
  
  @Deprecated('Ulanmaň: Bu ölçeg 16.0 bellenen. Ýerine "extraExtraLarge" ulanyň.')
  static const double xxl = 16.0;

  // --- TÄZE WE DOGRY ÖLÇEGLER (Täze kodlarda şulary ulanyň) ---
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double extraExtraLarge = 40.0;
  static const double massive = 48.0;
  static const double screenPadding = 16.0;
}
