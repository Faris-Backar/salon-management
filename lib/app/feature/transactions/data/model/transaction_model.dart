import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/employee/data/models/employee.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.uid,
    required super.createdAt,
    super.modifiedAt,
    required super.type,
    super.paymentMethod,
    required super.amount,
    super.employee,
    super.customer,
    super.discountAmount,
    super.selectedServices,
    super.expenseCategory,
    super.expenseDescription,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] == 'expense'
        ? TransactionType.expense
        : TransactionType.income;

    return TransactionModel(
      uid: json['uid'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      modifiedAt: json['modifiedAt'] != null
          ? (json['modifiedAt'] as Timestamp).toDate()
          : null,
      type: type,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      employee:
          json['employee'] != null && json['employee'] is Map<String, dynamic>
              ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
              : null,

      // For income transactions
      customer: type == TransactionType.income &&
              json.containsKey('customer') &&
              json['customer'] != null &&
              json['customer'] is Map<String, dynamic>
          ? CustomerEntity.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      discountAmount:
          type == TransactionType.income && json.containsKey('discountAmount')
              ? (json['discountAmount'] as num).toDouble()
              : null,
      selectedServices: type == TransactionType.income &&
              json.containsKey('selectedServices') &&
              json['selectedServices'] != null
          ? (json['selectedServices'] as List<dynamic>)
              .map((service) {
                if (service is Map<String, dynamic>) {
                  return ServiceItemEntity.fromJson(jsonEncode(service));
                }
                // Return null or a default service item if service is not a map
                return null;
              })
              .where((service) => service != null)
              .cast<ServiceItemEntity>()
              .toList()
          : null,

      // For expense transactions
      expenseCategory:
          type == TransactionType.expense && json.containsKey('expenseCategory')
              ? json['expenseCategory'] as String? ?? ''
              : null,
      expenseDescription: type == TransactionType.expense &&
              json.containsKey('expenseDescription')
          ? json['expenseDescription'] as String? ?? ''
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
      'type': type == TransactionType.expense ? 'expense' : 'income',
      'paymentMethod': paymentMethod,
      'amount': amount,
      'employee': employee?.toJson(),
    };

    // Add income-specific fields if this is an income transaction
    if (isIncome) {
      if (customer != null) {
        data['customer'] = customer!.toJson();
      }
      if (discountAmount != null) {
        data['discountAmount'] = discountAmount;
      }
      if (selectedServices != null && selectedServices!.isNotEmpty) {
        data['selectedServices'] =
            selectedServices!.map((s) => s.toJson()).toList();
      }
    }

    // Add expense-specific fields if this is an expense transaction
    if (isExpense) {
      if (expenseCategory != null) {
        data['expenseCategory'] = expenseCategory;
      }
      if (expenseDescription != null) {
        data['expenseDescription'] = expenseDescription;
      }
    }

    return data;
  }

  // Additional helper methods
  String get dateString =>
      "${createdAt.day}/${createdAt.month}/${createdAt.year}";

  String get description {
    if (isIncome) {
      return "Service for ${customer?.name ?? 'Unknown Customer'}";
    } else {
      return expenseCategory ?? "Expense";
    }
  }

  String get details {
    if (isIncome && selectedServices != null) {
      return selectedServices!.map((s) => s.name).join(", ");
    } else if (isExpense) {
      return expenseDescription ?? "";
    }
    return "";
  }

  @override
  String toString() {
    return 'TransactionModel(uid: $uid, createdAt: $createdAt, modifiedAt: $modifiedAt, type: $type, paymentMethod: $paymentMethod, amount: $amount, employee: $employee, customer: $customer, discountAmount: $discountAmount, selectedServices: $selectedServices, expenseCategory: $expenseCategory, expenseDescription: $expenseDescription)';
  }
}
