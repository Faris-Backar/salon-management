import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

class Employee extends EmployeeEntity {
  Employee({
    required super.uid,
    required super.fullname,
    required super.mobile,
    required super.contactAddress,
    required super.permenentAddress,
    required super.specialisation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      uid: json['uid'] as String,
      fullname: json['fullname'] as String,
      mobile: json['mobile'] as String,
      contactAddress: json['contactAddress'] as String,
      permenentAddress: json['permenentAddress'] as String,
      specialisation: json['specialisation'] as String,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullname': fullname,
      'mobile': mobile,
      'contactAddress': contactAddress,
      'permenentAddress': permenentAddress,
      'specialisation': specialisation,
    };
  }
}
