import 'package:flutter/material.dart';

class VendorModel {
  final String id;
  final String name;
  final String contactPerson;
  final String email;
  final String phone;
  final String address;

  const VendorModel({
    required this.id,
    required this.name,
    this.contactPerson = '',
    this.email = '',
    this.phone = '',
    this.address = '',
  });

  VendorModel copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? email,
    String? phone,
    String? address,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
