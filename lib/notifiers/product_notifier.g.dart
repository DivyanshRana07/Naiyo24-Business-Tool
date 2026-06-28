// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productNotifierHash() => r'cf2addc52a100ccd4af1258ad96fc62a69d65e72';

/// Manages the in-memory product catalog and persists changes to
/// [shared_preferences] under the key [_kProductsKey].
///
/// Architecture: UI → productNotifierProvider → ProductNotifier → State Update
///
/// Copied from [ProductNotifier].
@ProviderFor(ProductNotifier)
final productNotifierProvider =
    AutoDisposeNotifierProvider<ProductNotifier, List<ProductModel>>.internal(
  ProductNotifier.new,
  name: r'productNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductNotifier = AutoDisposeNotifier<List<ProductModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
