import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/service_model.dart';
import '../providers/shared_prefs_provider.dart';

part 'service_notifier.g.dart';

const _kServicesKey = 'services_list';

/// Manages the in-memory service catalog and persists changes to
/// [shared_preferences].
@riverpod
class ServiceNotifier extends _$ServiceNotifier {
  @override
  List<ServiceModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final raw = prefs.getString(_kServicesKey);
    if (raw == null) return _seedServices();
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _seedServices();
    }
  }

  // ---------- Mutations ----------

  void addService(ServiceModel service) {
    state = [...state, service];
    _persist();
  }

  void updateService(ServiceModel updated) {
    state = [
      for (final s in state) s.id == updated.id ? updated : s,
    ];
    _persist();
  }

  void deleteService(String id) {
    state = state.where((s) => s.id != id).toList();
    _persist();
  }

  // ---------- Queries ----------

  /// Returns active services whose name or code contains [query].
  /// Used to populate the autocomplete dropdown in the invoice form.
  List<ServiceModel> search(String query) {
    final q = query.toLowerCase();
    return state
        .where(
          (s) =>
              s.status == ServiceStatus.active &&
              (s.name.toLowerCase().contains(q) ||
                  s.code.toLowerCase().contains(q)),
        )
        .toList();
  }

  // ---------- Helpers ----------

  void _persist() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_kServicesKey, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  List<ServiceModel> _seedServices() => [
        const ServiceModel(
          id: 's-seed-001',
          code: 'S001',
          name: 'Home Delivery',
          category: 'Delivery',
          sellingPrice: 30.0,
          gstPercent: 18,
        ),
        const ServiceModel(
          id: 's-seed-002',
          code: 'S002',
          name: 'Consultation Fee',
          category: 'Consulting',
          sellingPrice: 200.0,
          gstPercent: 18,
        ),
        const ServiceModel(
          id: 's-seed-003',
          code: 'S003',
          name: 'Lab Test',
          category: 'Laboratory',
          sellingPrice: 150.0,
          gstPercent: 5,
        ),
      ];
}
