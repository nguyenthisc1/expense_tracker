import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';

/// Builds the MoneyFlow [ThemeData] for light and dark modes.
///
/// All visual decisions reference design tokens from [AppColors],
/// [AppTypography], and [AppRadius]. Do not hardcode values here.
abstract final class AppTheme {
  static ThemeData get light => _buildTheme(brightness: Brightness.light);
  static ThemeData get dark => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final bool isLight = brightness == Brightness.light;

    final Color primary =
        isLight ? AppColors.primary : AppColors.primaryDarkMode;
    final Color onPrimary =
        isLight ? AppColors.onPrimary : AppColors.onPrimaryDark;
    final Color primaryContainer = isLight
        ? AppColors.primaryContainer
        : AppColors.primaryContainerDark;
    final Color onPrimaryContainer = isLight
        ? AppColors.onPrimaryContainer
        : AppColors.onPrimaryContainerDark;

    final Color background =
        isLight ? AppColors.backgroundLight : AppColors.backgroundDark;
    final Color surface =
        isLight ? AppColors.surfaceLight : AppColors.surfaceDark;
    final Color surfaceVariant = isLight
        ? AppColors.surfaceVariantLight
        : AppColors.surfaceVariantDark;
    final Color onSurface = isLight
        ? AppColors.textPrimaryLight
        : AppColors.textPrimaryDark;
    final Color onSurfaceVariant = isLight
        ? AppColors.textSecondaryLight
        : AppColors.textSecondaryDark;
    final Color outline =
        isLight ? AppColors.borderLight : AppColors.borderDark;

    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: AppColors.emerald600,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.emerald100,
      onSecondaryContainer: AppColors.emerald900,
      tertiary: AppColors.slate500,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.slate100,
      onTertiaryContainer: AppColors.slate800,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorLight,
      onErrorContainer: const Color(0xFF7F1D1D),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: isLight ? AppColors.slate200 : AppColors.slate700,
      shadow: AppColors.slate900,
      scrim: AppColors.slate900,
      inverseSurface:
          isLight ? AppColors.slate900 : AppColors.slate50,
      onInverseSurface:
          isLight ? AppColors.slate50 : AppColors.slate900,
      inversePrimary: AppColors.emerald300,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      // Scaffold
      scaffoldBackgroundColor: background,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: onSurface,
        ),
        iconTheme: IconThemeData(
          color: isLight ? AppColors.iconLight : AppColors.iconDark,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      // Card
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: outline,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor:
            isLight ? AppColors.iconSubtleLight : AppColors.iconSubtleDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // NavigationBar (M3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: onPrimaryContainer);
          }
          return IconThemeData(
            color: isLight ? AppColors.iconLight : AppColors.iconDark,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: onPrimaryContainer,
              fontWeight: AppTypography.semiBold,
            );
          }
          return AppTypography.labelSmall.copyWith(
            color: isLight
                ? AppColors.textSecondaryLight
                : AppColors.textSecondaryDark,
          );
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),

      // Input / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(color: onSurfaceVariant),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isLight ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
        ),
        errorStyle: AppTypography.labelSmall.copyWith(color: AppColors.error),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: isLight
              ? AppColors.slate200
              : AppColors.slate700,
          disabledForegroundColor: isLight
              ? AppColors.textDisabledLight
              : AppColors.textDisabledDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryContainer,
        labelStyle: AppTypography.labelMedium.copyWith(color: onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.chip,
          side: BorderSide(color: outline),
        ),
        elevation: 0,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: isLight ? AppColors.iconLight : AppColors.iconDark,
        titleTextStyle: AppTypography.titleMedium.copyWith(color: onSurface),
        subtitleTextStyle:
            AppTypography.bodySmall.copyWith(color: onSurfaceVariant),
        tileColor: Colors.transparent,
      ),

      // BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheet,
        ),
        elevation: 0,
        showDragHandle: true,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        elevation: 0,
        backgroundColor: surface,
        titleTextStyle: AppTypography.headlineMedium.copyWith(color: onSurface),
        contentTextStyle:
            AppTypography.bodyMedium.copyWith(color: onSurfaceVariant),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isLight ? AppColors.slate800 : AppColors.slate100,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isLight ? AppColors.slate50 : AppColors.slate900,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: onSurface),
        displayMedium: AppTypography.displayMedium.copyWith(color: onSurface),
        displaySmall: AppTypography.displaySmall.copyWith(color: onSurface),
        headlineLarge:
            AppTypography.headlineLarge.copyWith(color: onSurface),
        headlineMedium:
            AppTypography.headlineMedium.copyWith(color: onSurface),
        headlineSmall:
            AppTypography.headlineSmall.copyWith(color: onSurface),
        titleLarge: AppTypography.titleLarge.copyWith(color: onSurface),
        titleMedium: AppTypography.titleMedium.copyWith(color: onSurface),
        titleSmall:
            AppTypography.titleSmall.copyWith(color: onSurfaceVariant),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: onSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: onSurface),
        bodySmall:
            AppTypography.bodySmall.copyWith(color: onSurfaceVariant),
        labelLarge: AppTypography.labelLarge.copyWith(color: onSurface),
        labelMedium: AppTypography.labelMedium.copyWith(color: onSurface),
        labelSmall:
            AppTypography.labelSmall.copyWith(color: onSurfaceVariant),
      ),
    );
  }
}
