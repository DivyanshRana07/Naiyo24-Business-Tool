import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ─── AppTextStyles ────────────────────────────────────────────────────────────
/// Centralised text style definitions using Inter (Google Fonts).
///
/// USAGE:
///   Text('Hello', style: AppTextStyles.h1)
///
/// Prefer using these over theme's textTheme for fine-grained control.
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppTextStyles {
  // ── Display / Headlines ──────────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get h4 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // ── Labels / Buttons ─────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      );

  // ── Navigation / Sidebar ─────────────────────────────────────────────────────
  static TextStyle get navItem => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get navItemActive => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  // ── Top Bar ──────────────────────────────────────────────────────────────────
  static TextStyle get topBarBrand => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textOnPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get topBarAction => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnPrimary,
      );

  // ── Login / Auth ─────────────────────────────────────────────────────────────
  static TextStyle get authTitle => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get authSubtitle => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Dashboard ────────────────────────────────────────────────────────────────
  static TextStyle get statNumber => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.1,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get statTrend => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardBody => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // ── Misc ─────────────────────────────────────────────────────────────────────
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );

  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  AppTextStyles._();
}
