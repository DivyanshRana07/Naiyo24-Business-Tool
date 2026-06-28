// ─── lib/routes/app_routes.dart ──────────────────────────────────────────────
// Route path constants – single source of truth.
//
// USAGE:
//   context.go(AppRoutes.dashboard);
//   if (state.matchedLocation == AppRoutes.login) { ... }
//
// Adding a new route:
//   1. Add the constant here.
//   2. Add a GoRoute entry in app_router.dart.
//   3. Create the screen widget in lib/screens/<name>/.
// ─────────────────────────────────────────────────────────────────────────────
abstract final class AppRoutes {
  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String splash    = '/';
  static const String login     = '/login';
  static const String signup    = '/signup';

  // ── Main App ──────────────────────────────────────────────────────────────
  static const String dashboard  = '/dashboard';
  static const String invoices   = '/invoices';
  static const String quotations = '/quotations';
  static const String purchases  = '/purchases';
  static const String clients    = '/clients';
  static const String products   = '/products';
  static const String reports    = '/reports';
  static const String settings   = '/settings';

  // ── Creation Sub-Routes ───────────────────────────────────────────────────
  static const String newInvoice   = '/invoices/new';
  static const String newQuotation = '/quotations/new';
  static const String newExpense   = '/expenses/new';
  static const String newClient    = '/clients/new';
  static const String newLead      = '/leads/new';
  static const String newProduct   = '/products/new';
  static const String sendReminder = '/reminders/new';
  static const String expenses     = '/expenses';
  static const String leads        = '/leads';

  // ── Auth-only helpers ─────────────────────────────────────────────────────
  static const Set<String> _authRoutes = {login, signup, splash};

  static const Set<String> _protectedRoutes = {
    dashboard,
    invoices,
    quotations,
    purchases,
    clients,
    products,
    reports,
    settings,
  };

  /// Returns `true` if [path] requires authentication.
  static bool isProtected(String path) => _protectedRoutes.contains(path);

  /// Returns `true` if [path] is an auth screen (login / signup).
  static bool isAuthScreen(String path) => _authRoutes.contains(path);

  AppRoutes._();
}
