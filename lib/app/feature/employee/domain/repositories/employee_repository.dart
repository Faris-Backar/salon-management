import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, bool>> createEmployee(
      {required EmployeeEnitity employee});
  Future<Either<Failure, List<EmployeeEnitity>>> getEmployees();
  Future<Either<Failure, bool>> updateEmployee(
      {required EmployeeEnitity employee});
  Future<Either<Failure, bool>> deleteEmployee({required String uid});
}
