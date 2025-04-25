import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/chart_legend_widget.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class MonthlyComparisonBarChartWidget extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;
  final DateTime fromDate;
  final DateTime toDate;
  final List<TransactionEntity> transactions;
  const MonthlyComparisonBarChartWidget({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
    this.isMobile = false,
    required this.fromDate,
    required this.toDate,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: AppStrings.indianRupee);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Comparison",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChartLegendWidget(color: Colors.green, label: 'Income'),
                const SizedBox(width: 16),
                ChartLegendWidget(color: Colors.red, label: 'Expense'),
                const SizedBox(width: 16),
                ChartLegendWidget(color: Colors.blue, label: 'Profit'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 300.h : 250.h,
              width: double.infinity,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String type;
                        if (rodIndex == 0) {
                          type = 'Income';
                        } else if (rodIndex == 1) {
                          type = 'Expense';
                        } else {
                          type = 'Profit';
                        }
                        return BarTooltipItem(
                          '$type: ${currencyFormatter.format(rod.toY)}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final monthIndex = value.toInt();
                          final monthNames = [
                            '',
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              monthNames[monthIndex],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(1)}k'
                                  : value.toStringAsFixed(0),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 100,
                  ),
                  borderData: FlBorderData(show: false),
                  // Add max Y to ensure space at the top of the chart
                  maxY: _getMaxYForBarChart(),
                  barGroups: _getMonthlyBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get data for bar chart (monthly averages)
  List<BarChartGroupData> _getMonthlyBarGroups() {
    // Group transactions by month
    Map<int, List<TransactionEntity>> monthlyTransactions = {};
    Map<int, double> monthlyIncomes = {};
    Map<int, double> monthlyExpenses = {};
    Map<int, double> monthlyProfits = {};
    Map<int, int> transactionCounts = {};

    // Initialize all months in the date range
    for (var d = fromDate;
        d.isBefore(toDate.add(const Duration(days: 1)));
        d = d.add(const Duration(days: 30))) {
      final month = d.month;
      if (!monthlyTransactions.containsKey(month)) {
        monthlyTransactions[month] = [];
        monthlyIncomes[month] = 0;
        monthlyExpenses[month] = 0;
        transactionCounts[month] = 0;
      }
    }

    for (var transaction in transactions) {
      final month = transaction.createdAt.month;

      if (!monthlyTransactions.containsKey(month)) {
        monthlyTransactions[month] = [];
        monthlyIncomes[month] = 0;
        monthlyExpenses[month] = 0;
        transactionCounts[month] = 0;
      }

      monthlyTransactions[month]!.add(transaction);
      transactionCounts[month] = transactionCounts[month]! + 1;

      if (transaction.isIncome) {
        monthlyIncomes[month] =
            monthlyIncomes[month]! + transaction.totalAmount;
      } else if (transaction.isExpense) {
        monthlyExpenses[month] =
            monthlyExpenses[month]! + transaction.totalAmount;
      }
    }

    // Calculate profits
    for (var month in monthlyIncomes.keys.toList()) {
      monthlyProfits[month] = monthlyIncomes[month]! - monthlyExpenses[month]!;
    }

    // Also calculate profits for months that might only have expenses
    for (var month in monthlyExpenses.keys) {
      if (!monthlyProfits.containsKey(month)) {
        monthlyProfits[month] = 0 - monthlyExpenses[month]!;
      }
    }

    // Create bar chart groups
    List<BarChartGroupData> barGroups = [];

    // Process all months in the map
    final allMonths = {...monthlyIncomes.keys, ...monthlyExpenses.keys};

    for (var month in allMonths) {
      final income = monthlyIncomes[month] ?? 0;
      final expense = monthlyExpenses[month] ?? 0;
      final profit = monthlyProfits[month] ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: income,
              color: Colors.green,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: expense,
              color: Colors.red,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: profit,
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  // Helper method to calculate max Y value for bar chart with extra space
  double _getMaxYForBarChart() {
    final barGroups = _getMonthlyBarGroups();
    if (barGroups.isEmpty) return 1000; // Default value if no data

    // Find the maximum Y value across all bar rods
    double maxY = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) maxY = rod.toY;
      }
    }

    // Add 20% extra space at the top
    return maxY * 1.2;
  }
}
