import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system: Noto Serif (scholarly headlines) + Plus Jakarta Sans (modern body).
abstract final class AppTypography {
  // ── Headlines (Noto Serif) ────────────────────────
  static TextStyle get displayLarge => GoogleFonts.notoSerif(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => GoogleFonts.notoSerif(
        fontSize: 45,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get displaySmall => GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineLarge => GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => GoogleFonts.notoSerif(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  // ── Titles (Plus Jakarta Sans) ────────────────────
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  // ── Body (Plus Jakarta Sans) ──────────────────────
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  // ── Labels (Plus Jakarta Sans) ────────────────────
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      );

  /// Builds the full [TextTheme] for [ThemeData].
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
