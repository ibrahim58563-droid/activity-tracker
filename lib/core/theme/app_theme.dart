import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Assembles the full Material 3 [ThemeData] from design tokens.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
      surfaceTint: AppColors.surfaceTint,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme,

      // ── AppBar ──────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
          fontStyle: FontStyle.italic,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      // ── Cards (surface-container-low, xl radius, no border) ──
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Buttons ─────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          side: BorderSide(color: AppColors.outlineVariant.withAlpha(77)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerHighest,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Inputs (underline-only, no border) ──────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withAlpha(77),
            width: 2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withAlpha(77),
            width: 2,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
          letterSpacing: 2,
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.outlineVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),

      // ── Checkbox (primary tint, rounded) ────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: AppColors.outline, width: 1.5),
      ),

      // ── Navigation bar ──────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background.withAlpha(204),
        indicatorColor: AppColors.secondary.withAlpha(13),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = AppTypography.labelSmall.copyWith(fontSize: 11);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: AppColors.secondary);
          }
          return base.copyWith(color: AppColors.primary.withAlpha(153));
        }),
      ),

      // ── Divider ─────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withAlpha(51),
        thickness: 1,
      ),
    );
  }
}
