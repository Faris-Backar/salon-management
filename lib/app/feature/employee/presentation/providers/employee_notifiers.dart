import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

import 'package:salon_management/app/feature/employee/domain/usecases/employee_usecase.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_state.dart';

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final EmployeeUsecase employeeUsecase;
  EmployeeNotifier({
    required this.employeeUsecase,
  }) : super(EmployeeState.initial());

  List<EmployeeEntity> employeeList = [];

  createEmployee({required EmployeeEntity employee}) async {
    state = EmployeeState.initial();
    state = EmployeeState.loading();
    final result =
        await employeeUsecase.createEmployee(employeeEntity: employee);
    result.fold((l) {
      state = EmployeeState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = EmployeeState.createEmployeeSuccess(isSuccess: r);
      return r;
    });
  }

  updateEmployee({required EmployeeEntity employee}) async {
    state = EmployeeState.initial();
    state = EmployeeState.loading();
    final result =
        await employeeUsecase.createEmployee(employeeEntity: employee);
    result.fold((l) {
      state = EmployeeState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = EmployeeState.updateEmployeeSuccess(isSuccess: r);
      return r;
    });
  }

  deleteEmployee({required String employeeUid}) async {
    state = EmployeeState.initial();
    state = EmployeeState.loading();
    final result =
        await employeeUsecase.deleteEmployees(employeeUid: employeeUid);
    result.fold((l) {
      state = EmployeeState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = EmployeeState.deleteEmployeeSuccess(isSuccess: r);
      return r;
    });
  }

  fetchEmployee() async {
    state = EmployeeState.initial();
    state = EmployeeState.loading();
    final result = await employeeUsecase.getEmployees();
    result.fold((l) {
      state = EmployeeState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      employeeList = r;
      state = EmployeeState.employeesFetched(employeeList: r);
      return r;
    });
  }
}
