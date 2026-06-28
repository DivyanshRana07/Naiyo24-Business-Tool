// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$invoiceNotifierHash() => r'5841080889e8302cc1c52b1d06a0ebc813b062ea';

/// Manages the full invoice history and persists to [shared_preferences].
///
/// On save, it automatically triggers stock deduction via [ProductNotifier].
///
/// Copied from [InvoiceNotifier].
@ProviderFor(InvoiceNotifier)
final invoiceNotifierProvider =
    AutoDisposeNotifierProvider<InvoiceNotifier, List<InvoiceModel>>.internal(
  InvoiceNotifier.new,
  name: r'invoiceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$invoiceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InvoiceNotifier = AutoDisposeNotifier<List<InvoiceModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
