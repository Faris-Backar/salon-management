import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'package:salon_management/app/feature/auth/domain/repositories/login_repository.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';

class RegisterWithEmail
    extends UseCase<Either<Failure, UserEntity>, LoginParams> {
  final AuthRepository authRepository;
  RegisterWithEmail({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, UserEntity>> call({required LoginParams params}) {
    return authRepository.registerWithEmail(loginParams: params);
  }
}
