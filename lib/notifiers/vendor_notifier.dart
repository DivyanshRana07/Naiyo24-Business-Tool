import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vendor_model.dart';
import 'package:uuid/uuid.dart';

part 'vendor_notifier.g.dart';

@riverpod
class VendorNotifier extends _$VendorNotifier {
  @override
  List<VendorModel> build() {
    return const [
      VendorModel(
        id: '1',
        name: 'TechSupplies Inc',
        contactPerson: 'John Doe',
        email: 'john@techsupplies.com',
        phone: '9876543210',
        address: '123 Tech Lane, Silicon Valley',
      ),
      VendorModel(
        id: '2',
        name: 'Office Depot',
        contactPerson: 'Jane Smith',
        email: 'jane@officedepot.com',
        phone: '1234567890',
        address: '456 Business Blvd, Downtown',
      ),
    ];
  }

  void addVendor(VendorModel vendor) {
    final newVendor = vendor.copyWith(id: const Uuid().v4());
    state = [...state, newVendor];
  }

  void updateVendor(VendorModel vendor) {
    state = [
      for (final v in state)
        if (v.id == vendor.id) vendor else v,
    ];
  }

  void deleteVendor(String id) {
    state = state.where((v) => v.id != id).toList();
  }
}
