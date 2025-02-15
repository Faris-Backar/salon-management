import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

class Employee extends EmployeeEnitity {
  Employee(
      {required super.uid,
      required super.fullname,
      required super.mobile,
      required super.contactAddress,
      required super.permenentAddress,
      required super.specialisation});
}
