import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'package:salon_management/app/feature/auth/domain/repositories/login_repository.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepositoryImpl(
      {required this.firebaseAuth, required this.firebaseFirestore});
  @override
  Future<Either<Failure, UserEntity>> signInwithEmail(
      {required LoginParams loginParams}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );
      return right(UserEntity(
          uid: "",
          firstName: "firstName",
          lastName: "lastName",
          email: "email",
          empNo: 0,
          createdAt: DateTime.now(),
          mobileNumber: ""));
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseAuthExceptionToFailure(e));
    }
  }

  Failure _mapFirebaseAuthExceptionToFailure(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'user-disabled':
        return const UserDisabledFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'invalid-credential':
        return const InvalidCredentialFailure();
      default:
        return ServerFailure(message: e.message ?? "Authentication failed");
    }
  }
}
