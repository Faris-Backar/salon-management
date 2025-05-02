import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/form_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/auth/presentation/widgets/register_button.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
                        validator: FormUtils.passWordValidator,
                      ),
                      const SizedBox(height: 30),
                      _PasswordField(
                        controller: _confirmPasswordController,
                        visibilityNotifier: _passwordVisibilityNotifier,
                        validator: (String? value) {
                          if (_passwordController.text != value) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      RegisterButton(
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
        InkWell(
          onTap: () => context.router.pushNamed(AppRouter.loginScreen),
          child: Text(
            " ${AppStrings.login}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool>? visibilityNotifier;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    this.visibilityNotifier,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (visibilityNotifier == null) {
      return CustomTextField(
        controller: controller,
        label: AppStrings.password,
        passwordvisibility: true,
        hint: AppStrings.enterPassword,
        textInputAction: TextInputAction.done,
        validator: validator,
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: visibilityNotifier!,
        builder: (context, isVisible, child) {
          return CustomTextField(
            controller: controller,
            label: AppStrings.confirmPassword,
            passwordvisibility: isVisible,
            hint: AppStrings.pleaseConfirmPassword,
            textInputAction: TextInputAction.done,
            validator: validator,
            suffixIcon: IconButton(
              onPressed: () => visibilityNotifier!.value = !isVisible,
              icon: Icon(isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
            ),
          );
        },
      );
    }
  }
}
