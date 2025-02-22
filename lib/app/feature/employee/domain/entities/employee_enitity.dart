class EmployeeEntity {
  final String uid;
  final String fullname;
  final String mobile;
  final String contactAddress;
  final String permenentAddress;
  final String specialisation;

  EmployeeEntity(
      {required this.uid,
      required this.fullname,
      required this.mobile,
      required this.contactAddress,
      required this.permenentAddress,
      required this.specialisation});

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

  factory EmployeeEntity.fromMap(Map<String, dynamic> map) {
    return EmployeeEntity(
      uid: map['uid'] ?? '',
      fullname: map['fullname'] ?? '',
      mobile: map['mobile'] ?? '',
      contactAddress: map['contactAddress'] ?? '',
      permenentAddress: map['permenentAddress'] ?? '',
      specialisation: map['specialisation'] ?? '',
    );
  }
}
