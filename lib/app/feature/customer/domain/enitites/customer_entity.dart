import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerEntity {
  final String uid;
  final String name;
  final String mobileNumber;
  final String address;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  CustomerEntity({
    required this.uid,
    required this.name,
    required this.mobileNumber,
    required this.address,
    this.createdAt,
    this.modifiedAt,
  });

  CustomerEntity copyWith({
    String? uid,
    String? name,
    String? mobileNumber,
    String? address,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return CustomerEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mobileNumber': mobileNumber,
      'address': address,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'modifiedAt': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
    };
  }

  factory CustomerEntity.fromMap(Map<String, dynamic> map) {
    return CustomerEntity(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      address: map['address'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      modifiedAt: map['modifiedAt'] != null
          ? (map['modifiedAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerEntity.fromJson(Map<String, dynamic> source) =>
      CustomerEntity.fromMap(source);

  @override
  String toString() {
    return 'CustomerEntity(uid: $uid, name: $name, mobileNumber: $mobileNumber, address: $address, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }
}
