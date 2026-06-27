/// Authentication state model.
///
/// Simple immutable value object – no backend, purely local boolean.
class AuthState {
  const AuthState({this.isLoggedIn = false, this.userEmail});

  final bool isLoggedIn;
  final String? userEmail;

  AuthState copyWith({bool? isLoggedIn, String? userEmail}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  String toString() =>
      'AuthState(isLoggedIn: $isLoggedIn, userEmail: $userEmail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isLoggedIn == isLoggedIn &&
        other.userEmail == userEmail;
  }

  @override
  int get hashCode => Object.hash(isLoggedIn, userEmail);
}
