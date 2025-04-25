import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';

class TransactionSummaryCardWidget extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color iconColor;
  final BuildContext context;
  final bool isCount;
  const TransactionSummaryCardWidget(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon,
      required this.iconColor,
      required this.context,
      this.isCount = false});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: AppStrings.indianRupee);
    final isDesktop = Responsive.isDesktop();
    final isTablet = Responsive.isTablet();

    double width = isDesktop
        ? 250.w
        : isTablet
            ? 180.w
            : MediaQuery.of(context).size.width * 0.44;

    return SizedBox(
      width: width,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isCount
                    ? amount.toInt().toString()
                    : currencyFormatter.format(amount),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
