import 'package:flutter/material.dart';

/// Emerald-slate color palette for MoneyFlow.
///
/// Emerald (primary brand): green-toned, energetic, trustworthy.
/// Slate (neutral): cool gray, professional, readable.
/// Both scales align with Tailwind CSS emerald/slate palettes.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Emerald scale (primary brand)
  // ---------------------------------------------------------------------------
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald300 = Color(0xFF6EE7B7);
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color emerald950 = Color(0xFF022C22);

  // ---------------------------------------------------------------------------
  // Slate scale (neutral)
  // ---------------------------------------------------------------------------
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // ---------------------------------------------------------------------------
  // Semantic aliases — Light theme
  // ---------------------------------------------------------------------------
  static const Color primary = emerald500;
  static const Color primaryLight = emerald400;
  static const Color primaryDark = emerald600;
  static const Color primaryContainer = emerald50;
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = emerald800;

  static const Color backgroundLight = slate50;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceVariantLight = slate100;
  static const Color borderLight = slate200;
  static const Color dividerLight = slate200;

  static const Color textPrimaryLight = slate900;
  static const Color textSecondaryLight = slate600;
  static const Color textTertiaryLight = slate400;
  static const Color textDisabledLight = slate300;

  static const Color iconLight = slate700;
  static const Color iconSubtleLight = slate400;

  // ---------------------------------------------------------------------------
  // Semantic aliases — Dark theme
  // ---------------------------------------------------------------------------
  static const Color primaryDarkMode = emerald400;
  static const Color primaryContainerDark = emerald900;
  static const Color onPrimaryDark = emerald950;
  static const Color onPrimaryContainerDark = emerald200;

  static const Color backgroundDark = slate950;
  static const Color surfaceDark = slate900;
  static const Color surfaceVariantDark = slate800;
  static const Color borderDark = slate700;
  static const Color dividerDark = slate800;

  static const Color textPrimaryDark = slate50;
  static const Color textSecondaryDark = slate400;
  static const Color textTertiaryDark = slate600;
  static const Color textDisabledDark = slate700;

  static const Color iconDark = slate300;
  static const Color iconSubtleDark = slate600;

  // ---------------------------------------------------------------------------
  // Semantic status colors
  // ---------------------------------------------------------------------------
  static const Color success = emerald500;
  static const Color successLight = emerald100;
  static const Color onSuccess = Colors.white;

  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // amber-100
  static const Color onWarning = Colors.white;

  static const Color error = Color(0xFFEF4444); // red-500
  static const Color errorLight = Color(0xFFFEE2E2); // red-100
  static const Color onError = Colors.white;

  static const Color info = Color(0xFF3B82F6); // blue-500
  static const Color infoLight = Color(0xFFEFF6FF); // blue-50
  static const Color onInfo = Colors.white;

  // ---------------------------------------------------------------------------
  // Transaction type colors
  // ---------------------------------------------------------------------------
  static const Color income = emerald500;
  static const Color incomeLight = emerald50;
  static const Color expense = Color(0xFFEF4444);
  static const Color expenseLight = Color(0xFFFEE2E2);
}
