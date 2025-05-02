import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';

class LoginButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: authState.maybeMap(
        loading: (_) => PrimaryButton(
            label: AppStrings.login, isLoading: true, onPressed: () {}),
        orElse: () => PrimaryButton(
          label: AppStrings.login,
          isLoading: false,
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              ref.read(authNotifierProvider.notifier).signIn(
                    emailController.text,
                    passwordController.text,
                  );
            }
          },
        ),
      ),
    );
  }
}
