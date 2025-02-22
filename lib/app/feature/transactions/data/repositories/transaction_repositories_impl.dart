import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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
}
