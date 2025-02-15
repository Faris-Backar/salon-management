import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final FirebaseFirestore firestore;

  EmployeeRepositoryImpl({required this.firestore});
  @override
  Future<Either<Failure, bool>> createEmployee(
      {required EmployeeEnitity employee}) async {
    try {
      final docRef =
          firestore.collection(FirebaseResources.employee).doc(employee.uid);
      log("Employee data => ${employee.toMap()}");
      await docRef.set(employee.toMap());
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmployee({required String uid}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<EmployeeEnitity>>> getEmployees() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateEmployee(
      {required EmployeeEnitity employee}) {
    throw UnimplementedError();
  }
}
