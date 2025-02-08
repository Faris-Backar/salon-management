import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User extends UserEntity with _$User {
  const factory User(
      {required String uid,
      required String firstName,
      required String lastName,
      required String email,
      required int empNo,
      required String mobileNumber,
      required DateTime createdAt}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
