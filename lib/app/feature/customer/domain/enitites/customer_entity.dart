import 'dart:convert';

class CustomerEntity {
  final String uid;
  final String name;
  final String mobileNumber;
  final String address;
  CustomerEntity(
      {required this.uid,
      required this.name,
      required this.mobileNumber,
      required this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mobileNumber': mobileNumber,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());
}
