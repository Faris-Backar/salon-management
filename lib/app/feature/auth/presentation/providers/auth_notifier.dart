import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/resources/pref_resources.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';

import 'package:salon_management/app/feature/auth/domain/usecases/signin_with_email.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SigninWithEmail signinWithEmail;
  AuthNotifier({
    required this.signinWithEmail,
  }) : super(AuthState.initial());

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    final result = await signinWithEmail(
        params: LoginParams(email: email, password: password));
    result.fold((failure) => state = AuthState.error(message: failure.message),
        (user) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(PrefResources.isAuthenticated, true);
      state = AuthState.authenticated(
        user: UserEntity(
            createdAt: DateTime.now(),
            uid: "",
            email: "",
            firstName: "",
            lastName: "",
            empNo: 0,
            mobileNumber: ""),
      );
    });
  }
}
