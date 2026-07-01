import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/purchase_order_model.dart';
import 'package:uuid/uuid.dart';

part 'purchase_order_notifier.g.dart';

@riverpod
class PurchaseOrderNotifier extends _$PurchaseOrderNotifier {
  @override
  List<PurchaseOrderModel> build() {
    return [
      PurchaseOrderModel(
        id: '1',
        poNumber: 'PO-001',
        title: 'Office Supplies',
        description: 'Pens, paper, staplers',
        vendorId: '2',
        vendorName: 'Office Depot',
        date: DateTime.now().subtract(const Duration(days: 2)),
        totalAmount: 150.00,
        status: POStatus.unpayed,
      ),
      PurchaseOrderModel(
        id: '2',
        poNumber: 'PO-002',
        title: 'Laptops for Dev Team',
        description: '2 MacBook Pros',
        vendorId: '1',
        vendorName: 'TechSupplies Inc',
        date: DateTime.now().subtract(const Duration(days: 5)),
        totalAmount: 4500.00,
        status: POStatus.payed,
      ),
    ];
  }

  void addPurchaseOrder(PurchaseOrderModel po) {
    final newPo = po.copyWith(id: const Uuid().v4());
    state = [newPo, ...state];
  }

  void updatePurchaseOrder(PurchaseOrderModel po) {
    state = [
      for (final p in state)
        if (p.id == po.id) po else p,
    ];
  }

  void toggleStatus(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
              status: p.status == POStatus.payed
                  ? POStatus.unpayed
                  : POStatus.payed)
        else
          p,
    ];
  }
}
