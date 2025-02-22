import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel(
      {required super.uid,
      required super.createdAt,
      required super.modifiedAt,
      required super.customer,
      required super.employee,
      required super.paymentMethod,
      required super.discountAmount,
      required super.totalAmount,
      required super.selectedServices});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      uid: json['uid'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      modifiedAt: (json['modifiedAt'] as Timestamp).toDate(),
      customer: json['customer'] as String,
      employee: json['employee'] as String,
      paymentMethod: json['paymentMethod'] as String,
      discountAmount: (json['discountAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      selectedServices: (json['selectedServices'] as List<dynamic>)
          .map((service) => Service.fromJson(service as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'customer': customer,
      'employee': employee,
      'paymentMethod': paymentMethod,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'selectedServices':
          selectedServices.map((service) => service.toJson()).toList(),
    };
  }
}

class Service {
  final String uid;
  final String categoryUid;
  final String categoryName;
  final bool isActive;
  final String name;
  final String price;

  Service({
    required this.uid,
    required this.categoryUid,
    required this.categoryName,
    required this.isActive,
    required this.name,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      uid: json['uid'] as String,
      categoryUid: json['categoryUid'] as String,
      categoryName: json['categoryName'] as String,
      isActive: json['isActive'] as bool,
      name: json['name'] as String,
      price: (json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'categoryUid': categoryUid,
      'categoryName': categoryName,
      'isActive': isActive,
      'name': name,
      'price': price,
    };
  }
}
