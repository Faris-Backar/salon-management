import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';

class StatRowWidget extends StatelessWidget {
  final String label;
  final double value;
  final bool isPercentage;
  const StatRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: AppStrings.indianRupee);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(1)}%'
                : currencyFormatter.format(value),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
