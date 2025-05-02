import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/registration_state.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';

class RegisterButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationNotifierProvider);

    ref.listen<RegistrationState>(registrationNotifierProvider,
        (previous, next) {
      next.maybeWhen(
        error: (message) {
          AppUtils.showSnackBar(context,
              content: message, isForErrorMessage: true);
        },
        success: () {
          AppUtils.showSnackBar(context,
              content: 'Registration successful!', isForErrorMessage: false);
          context.router.back();
        },
        orElse: () {},
      );
    });

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: registrationState.maybeMap(
        loading: (_) =>
            PrimaryButton(label: 'Register', isLoading: true, onPressed: () {}),
        orElse: () => PrimaryButton(
          label: 'Register',
          isLoading: false,
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              ref.read(registrationNotifierProvider.notifier).register(
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
