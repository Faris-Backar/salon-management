import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/register_with_email.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';

import 'registration_state.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final RegisterWithEmail registerWithEmail;
  RegistrationNotifier({required this.registerWithEmail})
      : super(const RegistrationState.initial());

  Future<void> register(String email, String password) async {
    try {
      state = const RegistrationState.loading();
      final result = await registerWithEmail.call(
        params: LoginParams(email: email, password: password),
      );
      result.fold(
        (failure) {
          state = RegistrationState.error(failure.message);
        },
        (user) {
          state = const RegistrationState.success();
        },
      );
    } on FirebaseAuthException catch (e) {
      state = RegistrationState.error(e.message ?? 'An error occurred');
    } catch (e) {
      state = RegistrationState.error(e.toString());
    }
  }
}
