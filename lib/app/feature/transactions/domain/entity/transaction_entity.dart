import 'package:salon_management/app/feature/transactions/data/model/transaction_model.dart';

class TransactionEntity {
  final String uid;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String customer;
  final String employee;
  final String paymentMethod;
  final double discountAmount;
  final double totalAmount;
  final List<Service> selectedServices;

  TransactionEntity(
      {required this.uid,
      required this.createdAt,
      required this.modifiedAt,
      required this.customer,
      required this.employee,
      required this.paymentMethod,
      required this.discountAmount,
      required this.totalAmount,
      required this.selectedServices});
}
