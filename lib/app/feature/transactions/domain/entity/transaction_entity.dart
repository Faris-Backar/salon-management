import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

class TransactionEntity {
  final String uid;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final TransactionType type;
  final String? paymentMethod;
  final double amount;
  final EmployeeEntity? employee;

  // Income-specific fields
  final CustomerEntity? customer;
  final double? discountAmount;
  final List<ServiceItemEntity>? selectedServices;

  // Expense-specific fields
  final String? expenseCategory;
  final String? expenseDescription;

  TransactionEntity({
    required this.uid,
    required this.createdAt,
    this.modifiedAt,
    required this.type,
    this.paymentMethod,
    required this.amount,
    this.employee,
    this.customer,
    this.discountAmount,
    this.selectedServices,
    this.expenseCategory,
    this.expenseDescription,
  });

  // Helper to check if this is an expense
  bool get isExpense => type == TransactionType.expense;

  // Helper to check if this is income
  bool get isIncome => type == TransactionType.income;

  // Get displayable amount based on transaction type
  double get displayAmount => amount;

  // Helper for UI to determine if transaction is positive or negative
  bool get isPositive => isIncome;

  // Calculate gross amount before discount
  double get grossAmount {
    if (isIncome) {
      return amount + (discountAmount ?? 0);
    }
    return amount;
  }

  // Calculate total amount after discount
  double get totalAmount {
    if (isIncome) {
      return amount; // amount is already post-discount
    }
    return amount; // For expenses, amount and totalAmount are the same
  }

  // Calculate discount percentage
  double get discountPercentage {
    if (isIncome && grossAmount > 0) {
      return ((discountAmount ?? 0) / grossAmount) * 100;
    }
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
      'type': type.name,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'employee': employee?.toJson(),
      'customer': customer?.toMap(),
      'discountAmount': discountAmount,
      'selectedServices': selectedServices?.map((x) => x.toMap()).toList(),
      'expenseCategory': expenseCategory,
      'expenseDescription': expenseDescription,
    };
  }

  @override
  String toString() {
    return 'TransactionEntity(uid: $uid, createdAt: $createdAt, modifiedAt: $modifiedAt, type: $type, paymentMethod: $paymentMethod, amount: $amount, employee: $employee, customer: $customer, discountAmount: $discountAmount, selectedServices: $selectedServices, expenseCategory: $expenseCategory, expenseDescription: $expenseDescription)';
  }
}

// Define transaction types
enum TransactionType {
  income,
  expense,
}
