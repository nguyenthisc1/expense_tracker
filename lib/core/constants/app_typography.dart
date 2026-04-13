import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale for MoneyFlow.
///
/// Uses the system default sans-serif font.
/// All sizes follow an 8pt grid harmonic scale.
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // Font sizes
  // ---------------------------------------------------------------------------
  static const double _xs = 11.0;
  static const double _sm = 13.0;
  static const double _base = 15.0;
  static const double _md = 16.0;
  static const double _lg = 18.0;
  static const double _xl = 20.0;
  static const double xl2 = 24.0;
  static const double xl3 = 30.0;
  static const double xl4 = 36.0;

  // ---------------------------------------------------------------------------
  // Font weights
  // ---------------------------------------------------------------------------
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ---------------------------------------------------------------------------
  // Line heights (as height multipliers)
  // ---------------------------------------------------------------------------
  static const double _tightHeight = 1.2;
  static const double _snugHeight = 1.375;
  static const double _normalHeight = 1.5;
  static const double _relaxedHeight = 1.625;

  // ---------------------------------------------------------------------------
  // Display styles (large headings, dashboard figures)
  // ---------------------------------------------------------------------------
  static const TextStyle displayLarge = TextStyle(
    fontSize: xl4,
    fontWeight: bold,
    height: _tightHeight,
    letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: xl3,
    fontWeight: bold,
    height: _tightHeight,
    letterSpacing: -0.25,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: xl2,
    fontWeight: semiBold,
    height: _snugHeight,
    color: AppColors.textPrimaryLight,
  );

  // ---------------------------------------------------------------------------
  // Headline styles (screen titles, section headers)
  // ---------------------------------------------------------------------------
  static const TextStyle headlineLarge = TextStyle(
    fontSize: _xl,
    fontWeight: semiBold,
    height: _snugHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: _lg,
    fontWeight: semiBold,
    height: _snugHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: _md,
    fontWeight: semiBold,
    height: _normalHeight,
    color: AppColors.textPrimaryLight,
  );

  // ---------------------------------------------------------------------------
  // Title styles (card titles, list headers)
  // ---------------------------------------------------------------------------
  static const TextStyle titleLarge = TextStyle(
    fontSize: _md,
    fontWeight: medium,
    height: _normalHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: _base,
    fontWeight: medium,
    height: _normalHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: _sm,
    fontWeight: medium,
    height: _normalHeight,
    color: AppColors.textSecondaryLight,
  );

  // ---------------------------------------------------------------------------
  // Body styles (content text)
  // ---------------------------------------------------------------------------
  static const TextStyle bodyLarge = TextStyle(
    fontSize: _md,
    fontWeight: regular,
    height: _relaxedHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: _base,
    fontWeight: regular,
    height: _normalHeight,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: _sm,
    fontWeight: regular,
    height: _normalHeight,
    color: AppColors.textSecondaryLight,
  );

  // ---------------------------------------------------------------------------
  // Label styles (buttons, chips, form labels)
  // ---------------------------------------------------------------------------
  static const TextStyle labelLarge = TextStyle(
    fontSize: _base,
    fontWeight: semiBold,
    height: _normalHeight,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: _sm,
    fontWeight: medium,
    height: _normalHeight,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: _xs,
    fontWeight: medium,
    height: _normalHeight,
    letterSpacing: 0.5,
    color: AppColors.textSecondaryLight,
  );

  // ---------------------------------------------------------------------------
  // Amount styles (transaction amounts — monospaced feel)
  // ---------------------------------------------------------------------------
  static const TextStyle amountLarge = TextStyle(
    fontSize: xl3,
    fontWeight: bold,
    height: _tightHeight,
    letterSpacing: -0.5,
  );

  static const TextStyle amountMedium = TextStyle(
    fontSize: _xl,
    fontWeight: semiBold,
    height: _snugHeight,
  );

  static const TextStyle amountSmall = TextStyle(
    fontSize: _md,
    fontWeight: semiBold,
    height: _normalHeight,
  );
}
