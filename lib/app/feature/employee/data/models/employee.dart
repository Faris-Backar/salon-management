import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee extends EmployeeEntity with _$Employee {
  const factory Employee({
    required String uid,
    required String fullname,
    required String mobile,
    required String contactAddress,
    required String permenentAddress,
    required String specialisation,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
}
