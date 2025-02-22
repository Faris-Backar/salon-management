import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, bool>> createEmployee(
      {required EmployeeEntity employee});
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees();
  Future<Either<Failure, bool>> updateEmployee(
      {required EmployeeEntity employee});
  Future<Either<Failure, bool>> deleteEmployee({required String uid});
}
