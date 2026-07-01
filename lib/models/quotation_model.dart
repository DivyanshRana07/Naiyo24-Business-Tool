import 'invoice_line_item.dart';

/// Represents a complete quotation document.
class QuotationModel {
  const QuotationModel({
    required this.id,
    required this.quotationNo,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerGst,
    required this.quotationDate,
    required this.validUntil,
    this.reference,
    required this.lineItems,
    required this.paymentTerms,
    required this.currency,
    this.terms,
    this.notes,
    this.attachedFilePath,
    this.status = QuotationStatus.draft,
  });

  final String id;

  /// Auto-generated quotation number, e.g. "QT-10045"
  final String quotationNo;

  // ---------- Customer snapshot ----------
  final String customerId;
  final String customerName;
  final String customerMobile;
  final String? customerAddress;
  final String? customerGst;

  final DateTime quotationDate;
  final DateTime validUntil;
  final String? reference;

  final List<InvoiceLineItem> lineItems;

  final String paymentTerms;
  final String currency;

  final String? terms;
  final String? notes;
  
  /// Path or name of the attached file
  final String? attachedFilePath;
  
  final QuotationStatus status;

  // ---------- Computed totals ----------

  double get subTotal =>
      lineItems.fold(0, (sum, item) => sum + (item.rate * item.qty));

  double get totalDiscount =>
      lineItems.fold(0, (sum, item) => sum + item.discountAmount);

  double get totalGst =>
      lineItems.fold(0, (sum, item) => sum + item.gstAmount);

  double get taxableAmount => subTotal - totalDiscount;

  double get grandTotal => taxableAmount + totalGst;

  QuotationModel copyWith({
    String? id,
    String? quotationNo,
    String? customerId,
    String? customerName,
    String? customerMobile,
    String? customerAddress,
    String? customerGst,
    DateTime? quotationDate,
    DateTime? validUntil,
    String? reference,
    List<InvoiceLineItem>? lineItems,
    String? paymentTerms,
    String? currency,
    String? terms,
    String? notes,
    String? attachedFilePath,
    QuotationStatus? status,
  }) {
    return QuotationModel(
      id: id ?? this.id,
      quotationNo: quotationNo ?? this.quotationNo,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      customerAddress: customerAddress ?? this.customerAddress,
      customerGst: customerGst ?? this.customerGst,
      quotationDate: quotationDate ?? this.quotationDate,
      validUntil: validUntil ?? this.validUntil,
      reference: reference ?? this.reference,
      lineItems: lineItems ?? this.lineItems,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      currency: currency ?? this.currency,
      terms: terms ?? this.terms,
      notes: notes ?? this.notes,
      attachedFilePath: attachedFilePath ?? this.attachedFilePath,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quotationNo': quotationNo,
        'customerId': customerId,
        'customerName': customerName,
        'customerMobile': customerMobile,
        'customerAddress': customerAddress,
        'customerGst': customerGst,
        'quotationDate': quotationDate.toIso8601String(),
        'validUntil': validUntil.toIso8601String(),
        'reference': reference,
        'lineItems': lineItems.map((e) => e.toJson()).toList(),
        'paymentTerms': paymentTerms,
        'currency': currency,
        'terms': terms,
        'notes': notes,
        'attachedFilePath': attachedFilePath,
        'status': status.name,
      };

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
        id: json['id'] as String,
        quotationNo: json['quotationNo'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        customerMobile: json['customerMobile'] as String,
        customerAddress: json['customerAddress'] as String?,
        customerGst: json['customerGst'] as String?,
        quotationDate: DateTime.parse(json['quotationDate'] as String),
        validUntil: DateTime.parse(json['validUntil'] as String),
        reference: json['reference'] as String?,
        lineItems: (json['lineItems'] as List)
            .map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        paymentTerms: json['paymentTerms'] as String? ?? 'Net 15 Days',
        currency: json['currency'] as String? ?? 'INR - Indian Rupee (₹)',
        terms: json['terms'] as String?,
        notes: json['notes'] as String?,
        attachedFilePath: json['attachedFilePath'] as String?,
        status: QuotationStatus.values.byName(
          json['status'] as String? ?? 'draft',
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is QuotationModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QuotationModel($quotationNo, customer: $customerName)';
}

enum QuotationStatus {
  draft,
  sent,
  viewed,
  accepted,
  rejected,
  expired,
}
