/// Animation duration tokens for MoneyFlow.
///
/// Use these for all AnimatedContainer, AnimatedOpacity, page transitions,
/// and any other time-based animations to maintain visual consistency.
abstract final class AppDurations {
  /// Near-instant micro interaction (e.g., ripple, color shift).
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast feedback (e.g., button press highlight).
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard UI transition (e.g., fade, slide, scale).
  static const Duration standard = Duration(milliseconds: 250);

  /// Slightly slower, used for drawer or bottom sheet entrance.
  static const Duration medium = Duration(milliseconds: 350);

  /// Slow, prominent animation (e.g., page transition, hero).
  static const Duration slow = Duration(milliseconds: 500);

  /// Long animation (e.g., onboarding, chart drawing).
  static const Duration xSlow = Duration(milliseconds: 800);

  // ---------------------------------------------------------------------------
  // Curve aliases — pair with durations above
  // ---------------------------------------------------------------------------
  // Use Curves.easeInOut for most transitions.
  // Use Curves.easeOut for elements entering the screen.
  // Use Curves.easeIn for elements leaving the screen.
  // Use Curves.elasticOut for bouncy entrance effects.
}
