import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
part 'employee_state.freezed.dart';

@freezed
class EmployeeState with _$EmployeeState {
  const factory EmployeeState.initial() = _Initial;
  const factory EmployeeState.loading() = _Loading;
  const factory EmployeeState.employeesFetched(
      {required List<EmployeeEnitity> employeeList}) = _EmployeesFetched;
  const factory EmployeeState.createEmployeeSuccess({required bool isSuccess}) =
      _CreateEmployeeSuccess;
  const factory EmployeeState.updateEmployeeSuccess({required bool isSuccess}) =
      _UpdateEmployeeSuccess;
  const factory EmployeeState.deleteEmployeeSuccess({required bool isSuccess}) =
      _DeleteEmployeeSuccess;
  const factory EmployeeState.failed({required String error}) = _Failed;
}
