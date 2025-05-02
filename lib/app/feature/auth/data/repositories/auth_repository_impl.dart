import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/feature/auth/data/models/user_model.dart';
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
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );
      if (userCredential.user != null) {
        final userDocument = await firebaseFirestore
            .collection(FirebaseResources.registeredUsers)
            .doc(userCredential.user!.uid)
            .get();

        if (userDocument.exists) {
          final user = UserModel.fromMap(userDocument.data() ?? {});
          return right(user);
        }
        return left(const UserNotFoundFailure());
      }
      return left(const UserNotFoundFailure());
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseAuthExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail(
      {required LoginParams loginParams}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );

      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          isActive: true,
          isAdmin: false,
          email: loginParams.email,
          createdAt: DateTime.now(),
        ).toMap();
        await firebaseFirestore
            .collection(FirebaseResources.registeredUsers)
            .doc(userCredential.user!.uid)
            .set(user);
      }
      return right(UserModel(
        id: userCredential.user?.uid ?? '',
        isActive: true,
        isAdmin: false,
        email: loginParams.email,
        createdAt: DateTime.now(),
      ));
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
