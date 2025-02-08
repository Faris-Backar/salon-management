import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/signin_with_email.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_notifier.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_state.dart';

final firebaseAuthProvider =
    Provider.autoDispose((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider.autoDispose((ref) => FirebaseFirestore.instance);

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(
      firebaseAuth: ref.read(firebaseAuthProvider),
      firebaseFirestore: ref.read(firebaseFirestoreProvider),
    ));

final signInProvider = Provider(
  (ref) => SigninWithEmail(authRepository: ref.read(authRepositoryProvider)),
);

// final resetPassswordUseCaseProvider = Provider(
//   (ref) => ResetPassword(authRepository: ref.watch(authRepositoryProvider)),
// );

// // final signOutUseCaseProvider = Provider(
// //   (ref) => SignOut(ref.watch(authRepositoryProvider)),
// // );

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    signinWithEmail: ref.read(signInProvider),
  ),
);
