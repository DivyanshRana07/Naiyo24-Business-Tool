import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// [AppShell] is the root widget of the application.
///
/// It wires together:
///   • [ProviderScope] (Riverpod)
///   • [MaterialApp.router] with GoRouter
///   • [AppTheme.lightTheme]
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Naiyo24 Business Tool',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // GoRouter integration
      routerConfig: router,
    );
  }
}
