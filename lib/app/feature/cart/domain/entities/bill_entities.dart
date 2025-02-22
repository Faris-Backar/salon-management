import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

class BillEntities {
  final String uid;
  final List<ServiceItemEntity> selectedServices;
  final CustomerEntity? customer;
  final EmployeeEntity? employee;
  final double totalAmount;
  final double discountAmount;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime modifiedAt;
  BillEntities({
    required this.uid,
    required this.selectedServices,
    this.customer,
    this.employee,
    required this.totalAmount,
    required this.discountAmount,
    required this.paymentMethod,
    required this.createdAt,
    required this.modifiedAt,
  });

  BillEntities copyWith({
    String? uid,
    List<ServiceItemEntity>? selectedServices,
    CustomerEntity? customer,
    EmployeeEntity? employee,
    double? totalAmount,
    double? discountAmount,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return BillEntities(
      uid: uid ?? this.uid,
      selectedServices: selectedServices ?? this.selectedServices,
      customer: customer ?? this.customer,
      employee: employee ?? this.employee,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'selectedServices': selectedServices.map((x) => x.toMap()).toList(),
      'customer': customer?.toMap() ?? "Guest",
      'employee': employee?.toJson() ?? "N/A",
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
    };
  }

  factory BillEntities.fromMap(Map<String, dynamic> map) {
    return BillEntities(
      uid: map['uid'] ?? '',
      selectedServices: List<ServiceItemEntity>.from(
          map['selectedServices']?.map((x) => ServiceItemEntity.fromMap(x))),
      customer: CustomerEntity.fromMap(map['customer']),
      employee: EmployeeEntity.fromMap(map['employee']),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      discountAmount: map['discountAmount']?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      modifiedAt: (map['modifiedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BillEntities.fromJson(String source) =>
      BillEntities.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BillEntities(uid: $uid, selectedServices: $selectedServices, customer: $customer, employee: $employee, totalAmount: $totalAmount, discountAmount: $discountAmount, paymentMethod: $paymentMethod, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillEntities &&
        other.uid == uid &&
        listEquals(other.selectedServices, selectedServices) &&
        other.customer == customer &&
        other.employee == employee &&
        other.totalAmount == totalAmount &&
        other.discountAmount == discountAmount &&
        other.paymentMethod == paymentMethod &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        selectedServices.hashCode ^
        customer.hashCode ^
        employee.hashCode ^
        totalAmount.hashCode ^
        discountAmount.hashCode ^
        paymentMethod.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode;
  }
}
