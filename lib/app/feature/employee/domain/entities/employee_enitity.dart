class EmployeeEnitity {
  final String uid;
  final String fullname;
  final String mobile;
  final String contactAddress;
  final String permenentAddress;
  final String specialisation;

  EmployeeEnitity(
      {required this.uid,
      required this.fullname,
      required this.mobile,
      required this.contactAddress,
      required this.permenentAddress,
      required this.specialisation});

  Map<String, dynamic> toMap() {
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
