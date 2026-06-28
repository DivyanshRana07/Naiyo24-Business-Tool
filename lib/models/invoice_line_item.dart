/// Represents a single line item on an invoice.
///
/// A line item can be either a [Product] or a [Service], distinguished by
/// [itemType]. Calculated fields ([gstAmount], [totalAmount]) are derived
/// from other fields and recomputed whenever the parent state changes.
class InvoiceLineItem {
  const InvoiceLineItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.code,
    required this.name,
    required this.qty,
    required this.rate,
    this.discountPercent = 0.0,
    this.gstPercent = 0.0,
  });

  final String id;

  /// Whether this item is a product or service
  final LineItemType itemType;

  /// The source ID in the Product or Service catalog
  final String itemId;

  final String code;
  final String name;

  final double qty;
  final double rate;

  /// Discount as a percentage (e.g. 5 = 5%)
  final double discountPercent;

  /// GST percentage applied (auto-filled from catalog)
  final double gstPercent;

  // ---------- Computed properties ----------

  double get discountAmount => (rate * qty) * (discountPercent / 100);
  double get baseAmount => (rate * qty) - discountAmount;
  double get gstAmount => baseAmount * (gstPercent / 100);
  double get totalAmount => baseAmount + gstAmount;

  InvoiceLineItem copyWith({
    String? id,
    LineItemType? itemType,
    String? itemId,
    String? code,
    String? name,
    double? qty,
    double? rate,
    double? discountPercent,
    double? gstPercent,
  }) {
    return InvoiceLineItem(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      code: code ?? this.code,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      rate: rate ?? this.rate,
      discountPercent: discountPercent ?? this.discountPercent,
      gstPercent: gstPercent ?? this.gstPercent,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemType': itemType.name,
        'itemId': itemId,
        'code': code,
        'name': name,
        'qty': qty,
        'rate': rate,
        'discountPercent': discountPercent,
        'gstPercent': gstPercent,
      };

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      InvoiceLineItem(
        id: json['id'] as String,
        itemType: LineItemType.values.byName(json['itemType'] as String),
        itemId: json['itemId'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        qty: (json['qty'] as num).toDouble(),
        rate: (json['rate'] as num).toDouble(),
        discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
        gstPercent: (json['gstPercent'] as num?)?.toDouble() ?? 0.0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is InvoiceLineItem && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

enum LineItemType { product, service }
