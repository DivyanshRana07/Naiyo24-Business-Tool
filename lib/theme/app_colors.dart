import 'package:flutter/material.dart';

/// ─── AppColors ───────────────────────────────────────────────────────────────
/// Single source of truth for every color used in Naiyo24 Business Tool.
/// Inspired by the Naiyo Business Tool purple-primary design system.
///
/// USAGE:
///   Color c = AppColors.primary;
///
/// DO NOT use Color(0x...) literals anywhere outside this file.
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppColors {
  // ── Primary Purple ──────────────────────────────────────────────────────────
  /// Main brand purple (#6D28D9 – Violet 700)
  static const Color primary = Color(0xFF6D28D9);

  /// Darker variant used for hover / pressed states (#5B21B6 – Violet 800)
  static const Color primaryDark = Color(0xFF5B21B6);

  /// Lighter variant for active tab backgrounds (#7C3AED – Violet 600)
  static const Color primaryMid = Color(0xFF7C3AED);

  /// Pale tint used for selected sidebar items / chips (#EDE9FE – Violet 100)
  static const Color primaryLight = Color(0xFFEDE9FE);

  /// Near-white tint for card hover states (#F5F3FF – Violet 50)
  static const Color primaryLightest = Color(0xFFF5F3FF);

  // ── Navbar Gradient ─────────────────────────────────────────────────────────
  /// Left stop of the purple navbar / hero gradient
  static const Color gradientStart = Color(0xFF6D28D9);

  /// Right stop of the purple navbar / hero gradient
  static const Color gradientEnd = Color(0xFF4F46E5);

  // ── Backgrounds ─────────────────────────────────────────────────────────────
  /// App-level scaffold background (near-white cool grey)
  static const Color background = Color(0xFFF8F7FF);

  /// Card / surface background (pure white)
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary surface for code blocks / alt cards
  static const Color surfaceVariant = Color(0xFFF4F4F8);

  /// Hover state for surface elements
  static const Color surfaceHover = Color(0xFFF0EEFF);

  // ── Sidebar ─────────────────────────────────────────────────────────────────
  /// Sidebar background (dark variant)
  static const Color sidebarBg = Color(0xFFFFFFFF);

  /// Sidebar selected item background
  static const Color sidebarSelected = Color(0xFFEDE9FE);

  /// Sidebar selected item left indicator bar
  static const Color sidebarIndicator = Color(0xFF6D28D9);

  // ── Text ────────────────────────────────────────────────────────────────────
  /// High-emphasis body / headline text
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Medium-emphasis labels, captions
  static const Color textSecondary = Color(0xFF6B7280);

  /// Low-emphasis placeholder / hint text
  static const Color textHint = Color(0xFFADB5BD);

  /// Text on primary-colored backgrounds (white)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on dark surfaces (light)
  static const Color textOnDark = Color(0xFFEDE9FE);

  // ── Borders ─────────────────────────────────────────────────────────────────
  /// Default input / card border
  static const Color border = Color(0xFFE5E7EB);

  /// Focused input border
  static const Color borderFocus = Color(0xFF6D28D9);

  /// Divider line
  static const Color divider = Color(0xFFE5E7EB);

  // ── Semantic Status ─────────────────────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ── Stat Card Accent Colors (matching screenshot icons) ─────────────────────
  /// Revenue card – indigo
  static const Color accentRevenue = Color(0xFF6D28D9);
  static const Color accentRevenueBg = Color(0xFFEDE9FE);

  /// Invoices card – amber / orange
  static const Color accentInvoice = Color(0xFFF59E0B);
  static const Color accentInvoiceBg = Color(0xFFFEF3C7);

  /// Clients card – green
  static const Color accentClient = Color(0xFF22C55E);
  static const Color accentClientBg = Color(0xFFDCFCE7);

  /// Overdue card – red
  static const Color accentOverdue = Color(0xFFEF4444);
  static const Color accentOverdueBg = Color(0xFFFEE2E2);

  // ── Top Bar ─────────────────────────────────────────────────────────────────
  /// Notification badge background
  static const Color notificationBadge = Color(0xFFEF4444);

  // ── Google Button ────────────────────────────────────────────────────────────
  static const Color googleButtonBg = Color(0xFFFFFFFF);
  static const Color googleButtonBorder = Color(0xFFDFE1E5);
  static const Color googleButtonText = Color(0xFF3C4043);

  // ── Misc ────────────────────────────────────────────────────────────────────
  /// Floating action / chat bubble
  static const Color chatBubble = Color(0xFF6D28D9);

  /// Transparent
  static const Color transparent = Colors.transparent;

  // Private constructor — use as namespace, not instance.
  AppColors._();
}
