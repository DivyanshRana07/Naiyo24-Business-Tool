import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_state.dart';
import '../notifiers/auth_notifier.dart';

export '../notifiers/auth_notifier.dart';

part 'auth_provider.g.dart';

/// Re-exports [authNotifierProvider] under the alias [authProvider] so that
/// the rest of the app uses a consistent naming convention.
///
/// Usage:
///   final authState = ref.watch(authProvider);
///   final notifier  = ref.read(authProvider.notifier);
@riverpod
AuthState auth(Ref ref) {
  return ref.watch(authNotifierProvider);
}
