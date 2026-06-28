// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerNotifierHash() => r'f29b67d7a65908bae97f79e37e6e524dbe1ec8b5';

/// Manages the in-memory customer directory and persists to
/// [shared_preferences].
///
/// Copied from [CustomerNotifier].
@ProviderFor(CustomerNotifier)
final customerNotifierProvider =
    AutoDisposeNotifierProvider<CustomerNotifier, List<CustomerModel>>.internal(
  CustomerNotifier.new,
  name: r'customerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerNotifier = AutoDisposeNotifier<List<CustomerModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
