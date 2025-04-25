import 'package:flutter/material.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/transaction_summary_card_widget.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class SummaryCardsWidget extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final double totalIncome;
  final double totalExpense;
  final double totalProfit;
  final List<TransactionEntity> transactions;
  const SummaryCardsWidget(
      {super.key,
      required this.isMobile,
      required this.isTablet,
      required this.isDesktop,
      required this.totalIncome,
      required this.totalExpense,
      required this.totalProfit,
      required this.transactions});

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TransactionSummaryCardWidget(
                      title: "Total Income",
                      amount: totalIncome,
                      icon: Icons.arrow_upward,
                      iconColor: Colors.green,
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: TransactionSummaryCardWidget(
                      title: "Total Expenses",
                      amount: totalExpense,
                      icon: Icons.arrow_downward,
                      iconColor: Colors.red,
                      context: context,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TransactionSummaryCardWidget(
                      title: "Net Profit",
                      amount: totalProfit,
                      icon: Icons.account_balance,
                      iconColor: Colors.blue,
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: TransactionSummaryCardWidget(
                      title: "Transactions",
                      amount: transactions.length.toDouble(),
                      isCount: true,
                      icon: Icons.receipt_long,
                      iconColor: Colors.purple,
                      context: context,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            spacing: 16,
            // runSpacing: 16,
            children: [
              Expanded(
                child: TransactionSummaryCardWidget(
                  title: "Total Income",
                  amount: totalIncome,
                  icon: Icons.arrow_upward,
                  iconColor: Colors.green,
                  context: context,
                ),
              ),
              Expanded(
                child: TransactionSummaryCardWidget(
                  title: "Total Expenses",
                  amount: totalExpense,
                  icon: Icons.arrow_downward,
                  iconColor: Colors.red,
                  context: context,
                ),
              ),
              Expanded(
                child: TransactionSummaryCardWidget(
                  title: "Net Profit",
                  amount: totalProfit,
                  icon: Icons.account_balance,
                  iconColor: Colors.blue,
                  context: context,
                ),
              ),
              Expanded(
                child: TransactionSummaryCardWidget(
                  title: "Transactions",
                  amount: transactions.length.toDouble(),
                  isCount: true,
                  icon: Icons.receipt_long,
                  iconColor: Colors.purple,
                  context: context,
                ),
              ),
            ],
          );
  }
}
