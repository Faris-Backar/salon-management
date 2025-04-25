import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/cart/domain/repository/checkout_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class CheckOutRepositoryImpl extends CheckoutRepository {
  final FirebaseFirestore firestore;

  CheckOutRepositoryImpl({required this.firestore});
  @override
  Future<Either<Failure, Unit>> checkout(
      {required TransactionEntity bill}) async {
    try {
      final docRef =
          firestore.collection(FirebaseResources.transactions).doc(bill.uid);
      await docRef.set(bill.toMap());
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }
}
