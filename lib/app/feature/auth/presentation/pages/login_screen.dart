import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/form_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/auth/presentation/widgets/login_button.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVisibilityNotifier = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 80.0),
          child: Card(
            elevation: isMobile ? 0 : 5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 30),
                      _buildEmailField(),
                      const SizedBox(height: 30),
                      _PasswordField(
                        controller: _passwordController,
                        visibilityNotifier: _passwordVisibilityNotifier,
                      ),
                      const SizedBox(height: 50),
                      LoginButton(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 20),
                      _buildSignupPrompt(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.welcomeBack,
          style: context.textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.enterYouremailAndPasswordToAccessYourAccount,
          style: context.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: AppStrings.email,
      controller: _emailController,
      hint: AppStrings.email,
      validator: FormUtils.emailValidator,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget _buildSignupPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${AppStrings.dontHaveAnAccount}?"),
        Text(
          " ${AppStrings.register}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> visibilityNotifier;

  const _PasswordField({
    required this.controller,
    required this.visibilityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visibilityNotifier,
      builder: (context, isVisible, child) {
        return CustomTextField(
          controller: controller,
          label: AppStrings.password,
          passwordvisibility: isVisible,
          hint: AppStrings.enterPassword,
          textInputAction: TextInputAction.done,
          validator: FormUtils.passWordValidator,
          suffixIcon: IconButton(
            onPressed: () => visibilityNotifier.value = !isVisible,
            icon: Icon(isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
          ),
        );
      },
    );
  }
}
