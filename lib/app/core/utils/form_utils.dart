import 'package:salon_management/app/core/app_strings.dart';

class FormUtils {
  FormUtils._();

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailCannotBeEmpty;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppStrings.enterValidEmail;
    }
    return null;
  }

  static String? passWordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return 'Full name can only contain letters and spaces';
    } else if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name';
    } else if (value.length < 3) {
      return 'Full name must be at least 3 characters long';
    }
    return null;
  }

  static String? mobileNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }
}
