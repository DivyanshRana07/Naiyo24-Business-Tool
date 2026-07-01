import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ─── AppGradients ─────────────────────────────────────────────────────────────
/// All LinearGradient / RadialGradient definitions used across the app.
///
/// USAGE:
///   Container(decoration: BoxDecoration(gradient: AppGradients.navbar))
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppGradients {
  // ── Top Navigation Bar / Hero Section ───────────────────────────────────────
  /// Purple-to-indigo used in the top navbar and dashboard hero banner.
  static const LinearGradient navbar = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Same gradient, top-to-bottom variant for hero banners.
  static const LinearGradient heroBanner = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Button Gradients ─────────────────────────────────────────────────────────
  /// Primary action button gradient (Sign In, Create Invoice, etc.)
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium / upgrade button (orange-red, like Naiyo Business Tool Premium Trial)
  static const LinearGradient premiumButton = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF3D7F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── Card / Surface Accents ───────────────────────────────────────────────────
  /// Subtle card hover shimmer
  static const LinearGradient cardShimmer = LinearGradient(
    colors: [Color(0xFFEDE9FE), Color(0xFFF5F3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Revenue stat-card accent
  static const LinearGradient revenueCard = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Sidebar Active Item ──────────────────────────────────────────────────────
  /// Left-side active indicator gradient
  static const LinearGradient sidebarIndicator = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF4F46E5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  AppGradients._();
}
