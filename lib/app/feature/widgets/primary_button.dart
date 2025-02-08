import 'package:flutter/material.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlineButton;
  final Widget? child;
  const PrimaryButton(
      {super.key,
      this.label = "",
      this.onPressed,
      this.isLoading = false,
      this.isOutlineButton = false,
      this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        backgroundColor:
            isOutlineButton ? null : context.colorScheme.onTertiaryFixed,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : child ??
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: isOutlineButton ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500),
              ),
    );
  }
}
