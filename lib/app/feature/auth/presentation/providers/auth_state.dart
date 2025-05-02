import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated({required UserEntity user}) =
      _Authenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error({required String message}) = _Error;
}
