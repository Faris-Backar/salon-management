import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/domain/repositories/employee_repository.dart';

class EmployeeUsecase extends UseCase<Either<Failure, EmployeeEnitity>, Unit> {
  final EmployeeRepository employeeRepository;
  EmployeeUsecase({
    required this.employeeRepository,
  });

  @override
  Future<Either<Failure, EmployeeEnitity>> call({required Unit params}) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> createEmployee(
      {required EmployeeEnitity employeeEntity}) {
    return employeeRepository.createEmployee(employee: employeeEntity);
  }

  Future<Either<Failure, List<EmployeeEnitity>>> getEmployees() {
    return employeeRepository.getEmployees();
  }

  Future<Either<Failure, bool>> updateEmployees(
      {required EmployeeEnitity employee}) {
    return employeeRepository.updateEmployee(employee: employee);
  }

  Future<Either<Failure, bool>> deleteEmployees({required String employeeUid}) {
    return employeeRepository.deleteEmployee(uid: employeeUid);
  }
}
