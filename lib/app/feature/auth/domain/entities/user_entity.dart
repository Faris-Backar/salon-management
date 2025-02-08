class UserEntity {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final int empNo;
  final DateTime createdAt;
  final String mobileNumber;

  UserEntity(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.empNo,
      required this.createdAt,
      required this.mobileNumber});
}
