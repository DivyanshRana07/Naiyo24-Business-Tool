/// Represents a physical product in the inventory.
///
/// Fields are derived from the "Products" section of the Inventory &
/// Billing System flow diagram (Image 2).
class ProductModel {
  const ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockQty,
    required this.gstPercent,
    this.status = ProductStatus.active,
  });

  final String id;

  /// Unique SKU / Code, e.g. "P001"
  final String code;

  final String name;
  final String category;

  /// Unit of measurement, e.g. "Strip", "Capsule", "Tablet", "Kg"
  final String unit;

  final double purchasePrice;
  final double sellingPrice;
  final int stockQty;

  /// GST percentage applied to this product (e.g. 12, 18)
  final double gstPercent;

  final ProductStatus status;

  ProductModel copyWith({
    String? id,
    String? code,
    String? name,
    String? category,
    String? unit,
    double? purchasePrice,
    double? sellingPrice,
    int? stockQty,
    double? gstPercent,
    ProductStatus? status,
  }) {
    return ProductModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQty: stockQty ?? this.stockQty,
      gstPercent: gstPercent ?? this.gstPercent,
      status: status ?? this.status,
    );
  }

  /// Serialise to a JSON-compatible map for [shared_preferences] storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'category': category,
        'unit': unit,
        'purchasePrice': purchasePrice,
        'sellingPrice': sellingPrice,
        'stockQty': stockQty,
        'gstPercent': gstPercent,
        'status': status.name,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        unit: json['unit'] as String,
        purchasePrice: (json['purchasePrice'] as num).toDouble(),
        sellingPrice: (json['sellingPrice'] as num).toDouble(),
        stockQty: (json['stockQty'] as num).toInt(),
        gstPercent: (json['gstPercent'] as num).toDouble(),
        status: ProductStatus.values.byName(
          json['status'] as String? ?? 'active',
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductModel(code: $code, name: $name)';
}

enum ProductStatus { active, inactive }
