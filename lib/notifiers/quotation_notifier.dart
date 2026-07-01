import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/quotation_model.dart';
import '../models/invoice_line_item.dart';

part 'quotation_notifier.g.dart';

@Riverpod(keepAlive: true)
class QuotationNotifier extends _$QuotationNotifier {
  @override
  List<QuotationModel> build() {
    // Initial dummy data for quotations
    return [
      QuotationModel(
        id: '1',
        quotationNo: 'QT-1001',
        customerId: 'c1',
        customerName: 'Acme Corp',
        customerMobile: '+91 9876543210',
        customerAddress: '123 Tech Park, Bangalore',
        customerGst: '29ABCDE1234F1Z5',
        quotationDate: DateTime.now().subtract(const Duration(days: 2)),
        validUntil: DateTime.now().add(const Duration(days: 13)),
        lineItems: [
          const InvoiceLineItem(
            id: 'l1',
            itemType: LineItemType.product,
            itemId: 'p1',
            name: 'MacBook Pro 16"',
            code: 'MBP-16',
            qty: 2,
            rate: 250000,
            discountPercent: 5,
            gstPercent: 18,
          ),
        ],
        paymentTerms: 'Net 15 Days',
        currency: 'INR - Indian Rupee (₹)',
        status: QuotationStatus.draft,
      ),
    ];
  }

  void addQuotation(QuotationModel quotation) {
    state = [quotation, ...state];
  }

  void updateQuotation(QuotationModel quotation) {
    state = [
      for (final q in state)
        if (q.id == quotation.id) quotation else q,
    ];
  }

  void deleteQuotation(String id) {
    state = state.where((q) => q.id != id).toList();
  }
}
