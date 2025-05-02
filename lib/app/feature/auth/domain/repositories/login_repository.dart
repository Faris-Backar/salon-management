import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInwithEmail(
      {required LoginParams loginParams});
  Future<Either<Failure, UserEntity>> registerWithEmail(
      {required LoginParams loginParams});
}
