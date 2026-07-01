// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRouterHash() => r'b2bc15531dc0dc2f721d89ab2c47d3841ded99e6';

/// ─── appRouterProvider ────────────────────────────────────────────────────────
/// Riverpod-generated provider that vends the [GoRouter] instance.
///
/// Key behaviours:
/// • Watches [authProvider] so the router reacts instantly to login / logout.
/// • Protects all routes under [AppRoutes._protectedRoutes] — unauthenticated
///   users are redirected to [AppRoutes.login].
/// • Authenticated users are redirected away from auth screens to
///   [AppRoutes.dashboard].
/// ─────────────────────────────────────────────────────────────────────────────
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
