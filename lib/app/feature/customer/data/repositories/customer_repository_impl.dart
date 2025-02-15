import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/customer/data/model/customer.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository {
  final FirebaseFirestore firestore;

  CustomerRepositoryImpl({required this.firestore});
  @override
  Future<Either<Failure, bool>> createCustomer(
      {required CustomerEntity customer}) async {
    try {
      final docRef =
          firestore.collection(FirebaseResources.customer).doc(customer.uid);
      await docRef.set(customer.toMap());
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCustomers({required String customerUid}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Customer>>> getCustomers() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateCustomers(
      {required CustomerEntity customer}) {
    throw UnimplementedError();
  }
}
