import 'package:flutter/material.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';

class AppUtils {
  AppUtils._();

  static showSnackBar(BuildContext context,
          {required String content, bool? isForErrorMessage}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            content,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.black,
            ),
          )));
}
