import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/resources/pref_resources.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/params/login_params.dart';
import 'package:salon_management/app/feature/auth/domain/usecases/signin_with_email.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SigninWithEmail signinWithEmail;
  AuthNotifier({required this.signinWithEmail})
      : super(const AuthState.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      state = const AuthState.loading();
      final result = await signinWithEmail(
          params: LoginParams(email: email, password: password));
      result
          .fold((failure) => state = AuthState.error(message: failure.message),
              (user) async {
        log("logged in user from auth notifier: $user");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(PrefResources.isAuthenticated, true);
        await prefs.setString(PrefResources.userId, user.id);
        await prefs.setString(PrefResources.userEmail, user.email);
        await prefs.setBool(PrefResources.isAdmin, user.isAdmin);
        await prefs.setBool(PrefResources.isActive, user.isActive);
        state = AuthState.authenticated(user: user);
      });
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(message: e.message ?? 'An error occurred');
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PrefResources.isAuthenticated, false);
      state = const AuthState.initial();
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }
}
