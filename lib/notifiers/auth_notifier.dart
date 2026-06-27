import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_state.dart';

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
  AuthState build() => const AuthState();

  /// Attempts login with [email] and [password].
  ///
  /// Returns `true` on success, `false` on invalid credentials.
  bool login(String email, String password) {
    if (email.trim() == _demoEmail &&
        password.trim() == _demoPassword) {
      state = state.copyWith(isLoggedIn: true, userEmail: email.trim());
      return true;
    }
    return false;
  }

  /// Logs out the current user.
  void logout() {
    state = const AuthState();
  }

  /// Returns whether the user is currently logged in.
  bool get isLoggedIn => state.isLoggedIn;
}
