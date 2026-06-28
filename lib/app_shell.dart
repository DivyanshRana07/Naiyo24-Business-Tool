import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── New canonical locations ────────────────────────────────────────────────────
import 'routes/app_router.dart';
import 'theme/theme.dart';

/// [AppShell] is the root widget of the application.
///
/// Wires together:
///   • [ProviderScope] (Riverpod — declared in main.dart)
///   • [MaterialApp.router] driven by GoRouter via [appRouterProvider]
///   • [AppTheme.light] — fully tokenised Material 3 theme
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Naiyo24 Business Tool',
      debugShowCheckedModeBanner: false,

      // ── Theme ──────────────────────────────────────────────────────────────
      theme: AppTheme.light,

      // ── GoRouter ───────────────────────────────────────────────────────────
      routerConfig: router,
    );
  }
}
