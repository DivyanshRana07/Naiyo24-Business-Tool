import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/customer_model.dart';
import '../providers/shared_prefs_provider.dart';

part 'customer_notifier.g.dart';

const _kCustomersKey = 'customers_list';

/// Manages the in-memory customer directory and persists to
/// [shared_preferences].
@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  List<CustomerModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final raw = prefs.getString(_kCustomersKey);
    if (raw == null) return _seedCustomers();
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedCustomers();
    }
  }

  // ---------- Mutations ----------

  void addCustomer(CustomerModel customer) {
    state = [...state, customer];
    _persist();
  }

  void updateCustomer(CustomerModel updated) {
    state = [
      for (final c in state) c.id == updated.id ? updated : c,
    ];
    _persist();
  }

  void deleteCustomer(String id) {
    state = state.where((c) => c.id != id).toList();
    _persist();
  }

  // ---------- Queries ----------

  /// Returns active customers whose name, mobile, or code contains [query].
  /// This is used to populate the "Select Customer" autocomplete dropdown.
  List<CustomerModel> search(String query) {
    final q = query.toLowerCase();
    return state
        .where(
          (c) =>
              c.status == CustomerStatus.active &&
              (c.name.toLowerCase().contains(q) ||
                  c.mobile.contains(q) ||
                  c.code.toLowerCase().contains(q)),
        )
        .toList();
  }

  /// Finds a single customer by [id]. Returns null if not found.
  CustomerModel? findById(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------- Helpers ----------

  void _persist() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_kCustomersKey, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  List<CustomerModel> _seedCustomers() => [
        const CustomerModel(
          id: 'c-seed-001',
          code: 'C001',
          name: 'Rahul Medical Store',
          mobile: '9876543210',
          address: '123, Baghajatin, Kolkata - 700086',
          gstNumber: '19ABCDE1234F1Z5',
          creditLimit: 10000.0,
          openingBalance: 0.0,
        ),
        const CustomerModel(
          id: 'c-seed-002',
          code: 'C002',
          name: 'New Life Medical',
          mobile: '9871234567',
          address: '123, Baghajatin, Kolkata',
          gstNumber: '19ABCDE1234F1Z5',
          creditLimit: 15000.0,
          openingBalance: 0.0,
        ),
        const CustomerModel(
          id: 'c-seed-003',
          code: 'C003',
          name: 'Health Care Pharmacy',
          mobile: '9831123344',
          creditLimit: 5000.0,
          openingBalance: 1250.0,
        ),
      ];
}
