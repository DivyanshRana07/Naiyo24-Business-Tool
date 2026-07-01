import 'package:flutter/material.dart';

enum POStatus {
  payed,
  unpayed,
}

class PurchaseOrderModel {
  final String id;
  final String poNumber;
  final String title;
  final String description;
  final String vendorId;
  final String vendorName;
  final DateTime date;
  final double totalAmount;
  final POStatus status;

  const PurchaseOrderModel({
    required this.id,
    required this.poNumber,
    required this.title,
    this.description = '',
    required this.vendorId,
    required this.vendorName,
    required this.date,
    required this.totalAmount,
    required this.status,
  });

  PurchaseOrderModel copyWith({
    String? id,
    String? poNumber,
    String? title,
    String? description,
    String? vendorId,
    String? vendorName,
    DateTime? date,
    double? totalAmount,
    POStatus? status,
  }) {
    return PurchaseOrderModel(
      id: id ?? this.id,
      poNumber: poNumber ?? this.poNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
