/// Icon size tokens for MoneyFlow.
///
/// Use these for all icon size arguments (size: AppIcons.md) to ensure
/// visual consistency across all icon usages.
abstract final class AppIcons {
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 28.0;
  static const double xl2 = 32.0;
  static const double xl3 = 40.0;
  static const double xl4 = 48.0;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  /// Standard icon in a list tile leading slot.
  static const double listTile = lg;

  /// Icon inside a button (leading/trailing).
  static const double button = md;

  /// Icon in navigation bar items.
  static const double navBar = lg;

  /// Icon in an AppBar action or title.
  static const double appBar = lg;

  /// Category icon displayed on a chip or badge.
  static const double categoryChip = sm;

  /// Large illustration icon on empty states.
  static const double emptyState = xl4;

  /// Icon in FAB.
  static const double fab = lg;
}
