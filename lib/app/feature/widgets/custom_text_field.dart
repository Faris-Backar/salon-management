import 'package:flutter/material.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/widgets/text_input_form_field.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool? passwordvisibility;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  const CustomTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.suffixIcon,
      this.passwordvisibility,
      this.hint,
      this.textInputAction,
      this.validator,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextInputFormField(
          controller: controller,
          suffixIcon: suffixIcon,
          isPasswordVisible: passwordvisibility,
          hintDecoration: context.textTheme.labelMedium
              ?.copyWith(color: context.colorScheme.outline),
          hint: hint,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          style: context.textTheme.labelLarge
              ?.copyWith(color: context.colorScheme.onSurface),
          textInputType: textInputType,
        ),
      ],
    );
  }
}
