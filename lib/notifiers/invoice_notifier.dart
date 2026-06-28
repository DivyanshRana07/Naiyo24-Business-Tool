import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/invoice_model.dart';
import '../models/invoice_line_item.dart';
import '../notifiers/product_notifier.dart';
import '../providers/shared_prefs_provider.dart';

part 'invoice_notifier.g.dart';

const _kInvoicesKey = 'invoices_list';
const _kInvoiceCounterKey = 'invoice_counter';

/// Manages the full invoice history and persists to [shared_preferences].
///
/// On save, it automatically triggers stock deduction via [ProductNotifier].
@riverpod
class InvoiceNotifier extends _$InvoiceNotifier {
  @override
  List<InvoiceModel> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final raw = prefs.getString(_kInvoicesKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------- Mutations ----------

  /// Saves a new invoice, auto-generates [invoiceNo], and deducts stock
  /// for all [LineItemType.product] line items.
  InvoiceModel saveInvoice(InvoiceModel invoice) {
    final prefs = ref.read(sharedPrefsProvider);

    // Auto-generate sequential invoice number
    final counter = (prefs.getInt(_kInvoiceCounterKey) ?? 10044) + 1;
    prefs.setInt(_kInvoiceCounterKey, counter);
    final numbered = invoice.copyWith(invoiceNo: 'INV-$counter');

    // Determine payment status
    final status = _resolveStatus(numbered);
    final finalInvoice = numbered.copyWith(status: status);

    state = [...state, finalInvoice];
    _persist();

    // Deduct stock for each product line item
    for (final item in finalInvoice.lineItems) {
      if (item.itemType == LineItemType.product) {
        ref
            .read(productNotifierProvider.notifier)
            .deductStock(item.itemId, item.qty.toInt());
      }
    }

    return finalInvoice;
  }

  /// Updates an existing invoice (e.g., marking a payment received).
  void updateInvoice(InvoiceModel updated) {
    final status = _resolveStatus(updated);
    final finalInvoice = updated.copyWith(status: status);
    state = [
      for (final inv in state) inv.id == finalInvoice.id ? finalInvoice : inv,
    ];
    _persist();
  }

  /// Deletes an invoice. Does NOT restore stock automatically; use
  /// [createCreditReturn] for proper credit/return flow.
  void deleteInvoice(String id) {
    state = state.where((inv) => inv.id != id).toList();
    _persist();
  }

  // ---------- Queries ----------

  /// Finds an invoice by [id]. Returns null if not found.
  InvoiceModel? findById(String id) {
    try {
      return state.firstWhere((inv) => inv.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns all invoices for a given [customerId], sorted by date descending.
  List<InvoiceModel> forCustomer(String customerId) {
    return state
        .where((inv) => inv.customerId == customerId)
        .toList()
      ..sort((a, b) => b.invoiceDate.compareTo(a.invoiceDate));
  }

  // ---------- Helpers ----------

  InvoiceStatus _resolveStatus(InvoiceModel invoice) {
    if (invoice.paidAmount <= 0) return InvoiceStatus.due;
    if (invoice.paidAmount >= invoice.grandTotal) return InvoiceStatus.paid;
    return InvoiceStatus.partial;
  }

  void _persist() {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(
      _kInvoicesKey,
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }
}
