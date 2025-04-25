import 'package:flutter/material.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/stat_row_widget.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class TransactionBreakdownCardWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final double totalTransactionAmount;
  final double totalIncome;
  final double totalExpense;
  final double totalProfit;
  const TransactionBreakdownCardWidget(
      {super.key,
      required this.transactions,
      required this.totalTransactionAmount,
      required this.totalIncome,
      required this.totalExpense,
      required this.totalProfit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction Breakdown",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            StatRowWidget(
              label: "Average Transaction Amount",
              value: transactions.isNotEmpty
                  ? totalTransactionAmount / transactions.length
                  : 0,
            ),
            const Divider(),
            StatRowWidget(
              label: "Average Daily Income",
              value: _calculateAverageDailyIncome(),
            ),
            const Divider(),
            StatRowWidget(
              label: "Average Daily Expense",
              value: _calculateAverageDailyExpense(),
            ),
            const Divider(),
            StatRowWidget(
              label: "Expense Ratio",
              value: totalIncome > 0 ? (totalExpense / totalIncome) * 100 : 0,
              isPercentage: true,
            ),
            const Divider(),
            StatRowWidget(
              label: "Profit Margin",
              value: totalIncome > 0 ? (totalProfit / totalIncome) * 100 : 0,
              isPercentage: true,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageDailyIncome() {
    // Get unique days in the transactions
    final Set<DateTime> uniqueDays = transactions
        .map((t) =>
            DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day))
        .toSet();

    if (uniqueDays.isEmpty) return 0;

    return totalIncome / uniqueDays.length;
  }

  double _calculateAverageDailyExpense() {
    // Get unique days in the transactions
    final Set<DateTime> uniqueDays = transactions
        .map((t) =>
            DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day))
        .toSet();

    if (uniqueDays.isEmpty) return 0;

    return totalExpense / uniqueDays.length;
  }
}
