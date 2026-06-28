/// ─── AppSpacing ───────────────────────────────────────────────────────────────
/// Spacing scale (4-point grid system).
///
/// USAGE:
///   SizedBox(height: AppSpacing.md)
///   padding: EdgeInsets.all(AppSpacing.lg)
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppSpacing {
  // ── Base Scale ───────────────────────────────────────────────────────────────
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ── Semantic Aliases ─────────────────────────────────────────────────────────
  /// Card internal padding
  static const double cardPadding = md;

  /// Section vertical gap
  static const double sectionGap = lg;

  /// Input field vertical internal padding
  static const double inputPaddingV = 14.0;

  /// Standard horizontal page margin
  static const double pageMarginH = lg;

  /// Dashboard grid gap
  static const double gridGap = md;

  // ── Sidebar ──────────────────────────────────────────────────────────────────
  static const double sidebarCollapsedWidth = 64.0;
  static const double sidebarExpandedWidth = 240.0;

  // ── Top Bar ──────────────────────────────────────────────────────────────────
  static const double topBarHeight = 60.0;
  static const double topBarPaddingH = 20.0;

  // ── Login Card ───────────────────────────────────────────────────────────────
  static const double loginCardMaxWidth = 480.0;
  static const double signupCardMaxWidth = 520.0;

  // ── Button ───────────────────────────────────────────────────────────────────
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 36.0;
  static const double inputHeight = 52.0;

  AppSpacing._();
}

/// ─── AppBorderRadius ──────────────────────────────────────────────────────────
/// Consistent border radius tokens.
///
/// USAGE:
///   BorderRadius.circular(AppBorderRadius.card)
/// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static const double full = 100.0;

  // ── Semantic Aliases ─────────────────────────────────────────────────────────
  static const double card = md;
  static const double button = md;
  static const double input = md;
  static const double chip = full;
  static const double avatar = full;
  static const double dialog = lg;
  static const double badge = full;
  static const double sidebar = md;

  AppBorderRadius._();
}
