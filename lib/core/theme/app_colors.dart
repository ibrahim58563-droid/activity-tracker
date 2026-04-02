import 'package:flutter/material.dart';

/// Color tokens extracted from the Stitch/DESIGN.md "Scholarly Manuscript" system.
abstract final class AppColors {
  // ── Core ──────────────────────────────────────────
  static const Color background = Color(0xFFFCF9F0); // Parchment
  static const Color surface = Color(0xFFFCF9F0);
  static const Color primary = Color(0xFF00342B); // Deep Teal
  static const Color primaryContainer = Color(0xFF004D40);
  static const Color secondary = Color(0xFF775A19); // Muted Gold
  static const Color tertiary = Color(0xFF3E271F);
  static const Color error = Color(0xFFBA1A1A);

  // ── On-colors ─────────────────────────────────────
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF7EBDAC);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1C17);
  static const Color onSurfaceVariant = Color(0xFF3F4945);
  static const Color onBackground = Color(0xFF1C1C17);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // ── Surface tiers ─────────────────────────────────
  static const Color surfaceBright = Color(0xFFFCF9F0);
  static const Color surfaceDim = Color(0xFFDDDAD1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3EA);
  static const Color surfaceContainer = Color(0xFFF1EEE5);
  static const Color surfaceContainerHigh = Color(0xFFEBE8DF);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DA);
  static const Color surfaceVariant = Color(0xFFE5E2DA);

  // ── Accents & utility ─────────────────────────────
  static const Color secondaryContainer = Color(0xFFFED488);
  static const Color onSecondaryContainer = Color(0xFF785A1A);
  static const Color tertiaryContainer = Color(0xFF573D34);
  static const Color onTertiaryContainer = Color(0xFFCCA89C);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color outline = Color(0xFF707975);
  static const Color outlineVariant = Color(0xFFBFC9C4);
  static const Color inverseSurface = Color(0xFF31312B);
  static const Color inverseOnSurface = Color(0xFFF4F1E8);
  static const Color inversePrimary = Color(0xFF94D3C1);
  static const Color surfaceTint = Color(0xFF29695B);

  // ── Fixed & dim tones ─────────────────────────────
  static const Color primaryFixed = Color(0xFFAFEFDD);
  static const Color primaryFixedDim = Color(0xFF94D3C1);
  static const Color secondaryFixed = Color(0xFFFFDEA5);
  static const Color secondaryFixedDim = Color(0xFFE9C176);
  static const Color tertiaryFixed = Color(0xFFFFDBCE);
  static const Color tertiaryFixedDim = Color(0xFFE4BEB2);
}
