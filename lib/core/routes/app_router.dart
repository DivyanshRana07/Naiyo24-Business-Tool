import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/auth_provider.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/signup/signup_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';

part 'app_router.g.dart';

/// Route name constants – avoids magic strings throughout the app.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    /// Global redirect: if the user tries to access /dashboard without being
    /// logged in, send them to /login; and vice-versa.
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.isLoggedIn;
      final isGoingToDashboard = state.matchedLocation == AppRoutes.dashboard;
      final isGoingToAuth =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      if (isGoingToDashboard && !isLoggedIn) return AppRoutes.login;
      if (isGoingToAuth && isLoggedIn) return AppRoutes.dashboard;
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SignupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
