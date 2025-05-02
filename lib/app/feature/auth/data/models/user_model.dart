import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'dart:convert';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.isActive,
    required super.isAdmin,
    required super.createdAt,
  });
  UserModel copyWith({
    String? id,
    String? email,
    bool? isActive,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'isActive': isActive,
      'isAdmin': isAdmin,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      isActive: map['isActive'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, isActive: $isActive, isAdmin: $isAdmin, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.isActive == isActive &&
        other.isAdmin == isAdmin &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        isActive.hashCode ^
        isAdmin.hashCode ^
        createdAt.hashCode;
  }
}
