import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation and shadow tokens for MoneyFlow.
///
/// Use these for all BoxShadow, Card elevation, and AppBar shadow values.
/// Dark mode shadows use a more subtle opacity since dark surfaces carry
/// less ambient light.
abstract final class AppShadows {
  static final List<BoxShadow> none = const [];

  static final List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.10),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.06),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> xl = [
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.16),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: AppColors.slate900.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Primary-colored glow for highlighted cards (income/emerald accent).
  static final List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.emerald500.withValues(alpha: 0.20),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];
}
