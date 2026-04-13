/// Spacing scale for MoneyFlow.
///
/// Based on a 4pt grid system. All padding, margin, gap,
/// and layout spacing values must reference these constants.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xl2 = 32.0;
  static const double xl3 = 40.0;
  static const double xl4 = 48.0;
  static const double xl5 = 64.0;
  static const double xl6 = 80.0;

  /// Standard page horizontal padding.
  static const double pageHorizontal = base;

  /// Standard page vertical padding (top/bottom safe area supplement).
  static const double pageVertical = lg;

  /// Standard card inner padding.
  static const double cardInner = base;

  /// Standard gap between list items.
  static const double listItemGap = sm;

  /// Standard gap between form fields.
  static const double formFieldGap = base;

  /// Standard bottom navigation / FAB clearance.
  static const double bottomBarClearance = 80.0;
}
