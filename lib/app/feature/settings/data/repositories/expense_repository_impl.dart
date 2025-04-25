import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/settings/domain/repository/expense_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;

  ExpenseRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> addExpense(
      TransactionEntity expenseTransaction) async {
    try {
      // Ensure the transaction is an expense
      if (!expenseTransaction.isExpense) {
        return Left(ServerFailure(message: "Transaction must be an expense"));
      }

      await firestore
          .collection(FirebaseResources.transactions)
          .doc(expenseTransaction.uid)
          .set(expenseTransaction.toMap());

      return const Right(null);
    } on FirebaseException catch (e) {
      log("Firebase error adding expense: ${e.message}");
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      log("Server error adding expense: $e");
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }
}
