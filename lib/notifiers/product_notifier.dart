import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/product_model.dart';
import '../providers/shared_prefs_provider.dart';

part 'product_notifier.g.dart';

const _kProductsKey = 'products_list';

/// Manages the in-memory product catalog and persists changes to
/// [shared_preferences] under the key [_kProductsKey].
///
/// Architecture: UI → productNotifierProvider → ProductNotifier → State Update
@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  List<ProductModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final raw = prefs.getString(_kProductsKey);
    if (raw == null) return _seedProducts();
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedProducts();
    }
  }

  // ---------- Mutations ----------

  /// Adds a new [product] to the catalog.
  void addProduct(ProductModel product) {
    state = [...state, product];
    _persist();
  }

  /// Replaces the product with matching [id].
  void updateProduct(ProductModel updated) {
    state = [
      for (final p in state) p.id == updated.id ? updated : p,
    ];
    _persist();
  }

  /// Removes the product with matching [id].
  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
    _persist();
  }

  /// Deducts [qty] from a product's stock when an invoice is saved.
  /// Silently skips if the product is not found.
  void deductStock(String productId, int qty) {
    state = [
      for (final p in state)
        if (p.id == productId)
          p.copyWith(stockQty: (p.stockQty - qty).clamp(0, 999999))
        else
          p,
    ];
    _persist();
  }

  /// Re-adds [qty] back to a product's stock when a return is processed.
  void restoreStock(String productId, int qty) {
    state = [
      for (final p in state)
        if (p.id == productId) p.copyWith(stockQty: p.stockQty + qty) else p,
    ];
    _persist();
  }

  // ---------- Queries ----------

  /// Returns products whose name or code contains [query] (case-insensitive).
  /// Used to populate the dropdown/autocomplete in the invoice form.
  List<ProductModel> search(String query) {
    final q = query.toLowerCase();
    return state
        .where(
          (p) =>
              p.status == ProductStatus.active &&
              (p.name.toLowerCase().contains(q) ||
                  p.code.toLowerCase().contains(q)),
        )
        .toList();
  }

  // ---------- Helpers ----------

  void _persist() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_kProductsKey, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  /// Demo seed data so the app is not empty on first launch.
  List<ProductModel> _seedProducts() => [
        const ProductModel(
          id: 'p-seed-001',
          code: 'P001',
          name: 'Paracetamol 650mg',
          category: 'Medicine',
          unit: 'Strip',
          purchasePrice: 15.0,
          sellingPrice: 22.0,
          stockQty: 120,
          gstPercent: 12,
        ),
        const ProductModel(
          id: 'p-seed-002',
          code: 'P002',
          name: 'Amoxicillin 250mg',
          category: 'Medicine',
          unit: 'Capsule',
          purchasePrice: 38.0,
          sellingPrice: 45.0,
          stockQty: 80,
          gstPercent: 12,
        ),
        const ProductModel(
          id: 'p-seed-003',
          code: 'P003',
          name: 'Vitamin D3 Tablet',
          category: 'Medicine',
          unit: 'Strip',
          purchasePrice: 28.0,
          sellingPrice: 35.0,
          stockQty: 100,
          gstPercent: 5,
        ),
      ];
}
