/// Design-system spacing tokens following the "Golden Thread" rhythm.
/// All values are divisible by 4 (the base unit).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Page margins (Design spec: token 8 = 2.75rem ≈ 44px).
  static const double pageMargin = 24;

  /// Section gaps (Design spec: token 16 = 5.5rem ≈ 88px).
  static const double sectionGap = 64;

  /// Standard card padding.
  static const double cardPadding = 24;

  /// Border radius tokens.
  static const double radiusDefault = 4;
  static const double radiusLg = 8;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  /// Arch (mihrab) top radius.
  static const double archRadius = 100;
}
