/// Represents a customer / client in the directory.
///
/// Fields derived from the "Customers" section of both flow diagram images.
class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.code,
    required this.name,
    required this.mobile,
    this.email,
    this.address,
    this.gstNumber,
    this.openingBalance = 0.0,
    this.creditLimit = 0.0,
    this.status = CustomerStatus.active,
  });

  final String id;

  /// Auto-generated code, e.g. "C001"
  final String code;

  final String name;
  final String mobile;
  final String? email;
  final String? address;

  /// GST registration number (GSTIN)
  final String? gstNumber;

  /// Existing balance before using this app (can be positive = advance paid,
  /// negative = amount owed).
  final double openingBalance;

  /// Maximum credit allowed for this customer
  final double creditLimit;

  final CustomerStatus status;

  /// Computed: amount available as credit (creditLimit - dues)
  /// Full calculation requires joining with invoices; stored separately if needed.

  CustomerModel copyWith({
    String? id,
    String? code,
    String? name,
    String? mobile,
    String? email,
    String? address,
    String? gstNumber,
    double? openingBalance,
    double? creditLimit,
    CustomerStatus? status,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      openingBalance: openingBalance ?? this.openingBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'mobile': mobile,
        'email': email,
        'address': address,
        'gstNumber': gstNumber,
        'openingBalance': openingBalance,
        'creditLimit': creditLimit,
        'status': status.name,
      };

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        mobile: json['mobile'] as String,
        email: json['email'] as String?,
        address: json['address'] as String?,
        gstNumber: json['gstNumber'] as String?,
        openingBalance: (json['openingBalance'] as num?)?.toDouble() ?? 0.0,
        creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0.0,
        status: CustomerStatus.values.byName(
          json['status'] as String? ?? 'active',
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CustomerModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomerModel(code: $code, name: $name)';
}

enum CustomerStatus { active, inactive }
