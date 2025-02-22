import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/employee/data/models/employee.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final FirebaseFirestore firestore;

  EmployeeRepositoryImpl({required this.firestore});
  @override
  Future<Either<Failure, bool>> createEmployee(
      {required EmployeeEntity employee}) async {
    try {
      final docRef =
          firestore.collection(FirebaseResources.employee).doc(employee.uid);
      log("Employee data => ${employee.toJson()}");
      await docRef.set(employee.toJson());
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
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees() async {
    try {
      final querySnapshot =
          await firestore.collection(FirebaseResources.employee).get();

      final employees = querySnapshot.docs.map((doc) {
        return Employee.fromJson(doc.data());
      }).toList();

      return Right(employees);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateEmployee(
      {required EmployeeEntity employee}) {
    throw UnimplementedError();
  }
}
