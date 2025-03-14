import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/transactions/data/model/transaction_model.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/repository/transaction_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/usecase/params/transaction_params.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore firestore;

  TransactionRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
      {required TransactionParams transParams}) async {
    try {
      final querySnapshot = await firestore
          .collection(FirebaseResources.transactions)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(transParams.fromDate))
          .where('createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(transParams.toDate))
          .get();
      List<TransactionEntity> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
      return Right(transactions);
    } on FirebaseException catch (e) {
      log("here in firebase exception ${e.message}");
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      log("here in server exception $e");
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByCustomerId(
      {required String customerId}) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('transactions')
          .where('customer', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionEntity(
          uid: doc['uid'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          modifiedAt: (doc['modifiedAt'] as Timestamp).toDate(),
          customer: doc['customer'],
          employee: doc['employee'],
          paymentMethod: doc['paymentMethod'],
          discountAmount: (doc['discountAmount'] as num).toDouble(),
          totalAmount: (doc['totalAmount'] as num).toDouble(),
          selectedServices: (doc['selectedServices'] as List<dynamic>)
              .map((service) => Service(
                    uid: service['uid'],
                    categoryUid: service['categoryUid'],
                    categoryName: service['categoryName'],
                    isActive: service['isActive'],
                    name: service['name'],
                    price: service['price'],
                  ))
              .toList(),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching transactions: $e');
      }
      return [];
    }
  }
}
