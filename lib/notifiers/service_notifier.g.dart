// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceNotifierHash() => r'79df96408ef8dc420bcba3a8b863f56ad5786c5f';

/// Manages the in-memory service catalog and persists changes to
/// [shared_preferences].
///
/// Copied from [ServiceNotifier].
@ProviderFor(ServiceNotifier)
final serviceNotifierProvider =
    AutoDisposeNotifierProvider<ServiceNotifier, List<ServiceModel>>.internal(
  ServiceNotifier.new,
  name: r'serviceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serviceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServiceNotifier = AutoDisposeNotifier<List<ServiceModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
