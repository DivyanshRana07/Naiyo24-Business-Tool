import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_state.dart';
import '../providers/shared_prefs_provider.dart';

part 'auth_notifier.g.dart';

/// Demo credentials – frontend-only, no backend.
const String _demoEmail = 'demo@refrens.com';
const String _demoPassword = 'demo123';

/// [AuthNotifier] manages authentication state locally.
///
/// Architecture: UI → Provider → Notifier → State Update
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    final userEmail = prefs.getString('userEmail');
    return AuthState(
      isLoggedIn: isLoggedIn,
      hasCompletedOnboarding: hasCompletedOnboarding,
      userEmail: userEmail,
    );
  }

  /// Attempts login with [email] and [password].
  ///
  /// Returns `true` on success, `false` on invalid credentials.
  bool login(String email, String password) {
    if (email.trim() == _demoEmail &&
        password.trim() == _demoPassword) {
      final cleanEmail = email.trim();
      state = state.copyWith(isLoggedIn: true, userEmail: cleanEmail);
      
      final prefs = ref.read(sharedPrefsProvider);
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userEmail', cleanEmail);
      
      return true;
    }
    return false;
  }

  /// Bypasses demo credential check and logs the user in immediately.
  /// Used right after a successful registration.
  void forceLogin(String email) {
    final cleanEmail = email.trim();
    state = state.copyWith(isLoggedIn: true, userEmail: cleanEmail);
    
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userEmail', cleanEmail);
  }

  /// Marks the onboarding flow as completed.
  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setBool('hasCompletedOnboarding', true);
  }

  /// Logs out the current user.
  void logout() {
    state = const AuthState();
    final prefs = ref.read(sharedPrefsProvider);
    prefs.remove('isLoggedIn');
    prefs.remove('userEmail');
    // We intentionally do NOT remove 'hasCompletedOnboarding' so returning users
    // don't have to repeat the onboarding process after logging back in.
  }

  /// Returns whether the user is currently logged in.
  bool get isLoggedIn => state.isLoggedIn;
}
