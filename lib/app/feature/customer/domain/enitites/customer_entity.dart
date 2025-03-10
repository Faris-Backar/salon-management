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

  factory CustomerEntity.fromMap(Map<String, dynamic> map) {
    return CustomerEntity(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  factory CustomerEntity.fromJson(Map<String, dynamic> source) =>
      CustomerEntity.fromMap(source);

  CustomerEntity copyWith({
    String? uid,
    String? name,
    String? mobileNumber,
    String? address,
  }) {
    return CustomerEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
    );
  }
}
