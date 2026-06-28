// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authHash() => r'8edfd09b298028cbea78006143daec1affa1f830';

/// Re-exports [authNotifierProvider] under the alias [authProvider] so that
/// the rest of the app uses a consistent naming convention.
///
/// Usage:
///   final authState = ref.watch(authProvider);
///   final notifier  = ref.read(authProvider.notifier);
///
/// Copied from [auth].
@ProviderFor(auth)
final authProvider = AutoDisposeProvider<AuthState>.internal(
  auth,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRef = AutoDisposeProviderRef<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
