import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/reports/presentation/functions/generate_pdf_and_csv_files.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/chart_legend_widget.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/monthly_comparison_bar_chart_widget.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/stat_row_widget.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/summary_cards_widget.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/transaction_breakdown_card_widget.dart';
import 'package:salon_management/app/feature/reports/presentation/widgets/transaction_summary_card_widget.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/presentations/notifiers/transaction_notifiers.dart';

@RoutePage()
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Transaction Report Variables
  List<TransactionEntity> transactions = [];
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  double _totalTransactionAmount = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  // Chart data view selection
  String _selectedDataView = 'profit'; // income, expense, profit

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Don't call _fetchTransactions directly in initState
    // Instead use a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTransactions();
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    // Set date range in the providers
    ref.read(fromDateProvider.notifier).state = _fromDate;
    ref.read(toDateProvider.notifier).state = _toDate;

    // Directly fetch the transactions without using ref.listen
    try {
      await ref.refresh(transactionsProvider.future);
      final transactionData = await ref.read(transactionsProvider.future);

      if (mounted) {
        setState(() {
          transactions = transactionData;
          _calculateTotals();
          debugPrint('Fetched ${transactions.length} transactions');
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading transactions: $e');
      debugPrint(stackTrace.toString());
    }
  }

  void _calculateTotals() {
    _totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.totalAmount);

    _totalExpense = transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.totalAmount);

    _totalTransactionAmount = _totalIncome;
  }

  double get _totalProfit => _totalIncome - _totalExpense;

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _fromDate, end: _toDate),
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });

      // Update providers directly when range changes
      ref.read(fromDateProvider.notifier).state = _fromDate;
      ref.read(toDateProvider.notifier).state = _toDate;
    }
  }

  Future<void> _selectFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });

      // Update provider
      ref.read(fromDateProvider.notifier).state = _fromDate;
      // Refresh data
      _fetchTransactions();
    }
  }

  Future<void> _selectToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });

      // Update provider
      ref.read(toDateProvider.notifier).state = _toDate;
      // Refresh data
      _fetchTransactions();
    }
  }

  // Get data for line chart (daily transactions)
  List<FlSpot> _getDailyChartData() {
    final Map<DateTime, double> dailyTotals = {};
    final Map<DateTime, double> dailyExpenses = {};
    final Map<DateTime, double> dailyProfits = {};

    // Fill in all dates in the range, even with zero values
    for (var d = _fromDate;
        d.isBefore(_toDate.add(const Duration(days: 1)));
        d = d.add(const Duration(days: 1))) {
      final date = DateTime(d.year, d.month, d.day);
      dailyTotals[date] = 0;
      dailyExpenses[date] = 0;
      dailyProfits[date] = 0;
    }

    // Add transaction data
    for (var transaction in transactions) {
      final date = DateTime(transaction.createdAt.year,
          transaction.createdAt.month, transaction.createdAt.day);

      if (transaction.isIncome) {
        dailyTotals[date] = (dailyTotals[date] ?? 0) + transaction.totalAmount;
      } else if (transaction.isExpense) {
        dailyExpenses[date] =
            (dailyExpenses[date] ?? 0) + transaction.totalAmount;
      }
    }

    // Calculate profits
    for (var entry in dailyTotals.entries) {
      final dateKey = entry.key;
      final income = entry.value;
      final expense = dailyExpenses[dateKey] ?? 0;
      dailyProfits[dateKey] = income - expense;
    }

    // Convert to spots for the chart based on selected data
    Map<DateTime, double> selectedData;
    switch (_selectedDataView) {
      case 'income':
        selectedData = dailyTotals;
        break;
      case 'expense':
        selectedData = dailyExpenses;
        break;
      case 'profit':
      default:
        selectedData = dailyProfits;
        break;
    }

    final List<FlSpot> spots = [];

    // Only add points if we actually have data to show
    if (selectedData.isNotEmpty) {
      spots.addAll(selectedData.entries
          .map((entry) =>
              FlSpot(entry.key.millisecondsSinceEpoch.toDouble(), entry.value))
          .toList());

      spots.sort((a, b) => a.x.compareTo(b.x));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop();
    final isTablet = Responsive.isTablet();
    final isMobile = Responsive.isMobile();

    // Move the ref.listen inside the build method
    ref.listen<AsyncValue<List<TransactionEntity>>>(
      transactionsProvider,
      (previous, current) {
        current.when(
          data: (data) {
            if (mounted) {
              setState(() {
                transactions = data;
                _calculateTotals();
                debugPrint(
                    'Updated ${transactions.length} transactions from listener');
              });
            }
          },
          loading: () {
            debugPrint('Loading transactions...');
          },
          error: (error, stackTrace) {
            debugPrint('Error loading transactions: $error');
            debugPrint(stackTrace.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(AppStrings.reports),
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectFromDate,
                  tooltip: 'Select From Date',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _selectToDate,
                  tooltip: 'Select To Date',
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.w : 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction Overview",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      // Individual date selectors
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          "From: ${DateFormat('MMM d, y').format(_fromDate)}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: _selectFromDate,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          "To: ${DateFormat('MMM d, y').format(_toDate)}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: _selectToDate,
                      ),
                      const SizedBox(width: 8),
                      // Export options
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf),
                        onPressed: () => exportToPDF(
                            fromDate: _fromDate,
                            toDate: _toDate,
                            totalTransactionAmount: _totalTransactionAmount,
                            transactions: transactions),
                        tooltip: 'Export to PDF',
                      ),
                      IconButton(
                        icon: const Icon(Icons.table_chart),
                        onPressed: () =>
                            exportToCSV(transactions: transactions),
                        tooltip: 'Export to CSV',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Summary Cards
              SummaryCardsWidget(
                isMobile: isMobile,
                isTablet: isTablet,
                isDesktop: isDesktop,
                totalIncome: _totalIncome,
                totalExpense: _totalExpense,
                totalProfit: _totalProfit,
                transactions: transactions,
              ),
              const SizedBox(height: 32),

              // Daily transactions chart
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daily Transaction Trends",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          // View selector (income, expense, profit)
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'income',
                                label: Text('Income'),
                              ),
                              ButtonSegment(
                                value: 'expense',
                                label: Text('Expense'),
                              ),
                              ButtonSegment(
                                value: 'profit',
                                label: Text('Profit'),
                              ),
                            ],
                            selected: {_selectedDataView},
                            onSelectionChanged: (Set<String> selection) {
                              setState(() {
                                _selectedDataView = selection.first;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: isDesktop ? 300.h : 250.h,
                        width: double.infinity,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    DateTime date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "${date.day}/${date.month}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        value >= 1000
                                            ? '${(value / 1000).toStringAsFixed(1)}k'
                                            : value.toStringAsFixed(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                            borderData: FlBorderData(show: true),
                            // Add max Y to ensure space at the top of the chart
                            maxY: _getMaxYForLineChart(),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getDailyChartData(),
                                isCurved: true,
                                barWidth: 4,
                                color: _selectedDataView == 'income'
                                    ? Colors.green
                                    : _selectedDataView == 'expense'
                                        ? Colors.red
                                        : Colors.blue,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: (_selectedDataView == 'income'
                                          ? Colors.green
                                          : _selectedDataView == 'expense'
                                              ? Colors.red
                                              : Colors.blue)
                                      .withValues(alpha: 0.2),
                                ),
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Monthly comparison bar chart
              MonthlyComparisonBarChartWidget(
                isDesktop: isDesktop,
                isTablet: isTablet,
                isMobile: isMobile,
                fromDate: _fromDate,
                toDate: _toDate,
                transactions: transactions,
              ),

              const SizedBox(height: 32),

              // Transaction breakdown card
              TransactionBreakdownCardWidget(
                transactions: transactions,
                totalTransactionAmount: _totalTransactionAmount,
                totalIncome: _totalIncome,
                totalExpense: _totalExpense,
                totalProfit: _totalProfit,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to calculate max Y value for line chart with extra space
  double _getMaxYForLineChart() {
    final spots = _getDailyChartData();
    if (spots.isEmpty) return 1000; // Default value if no data

    // Find the maximum Y value in the spots
    double maxY =
        spots.map((spot) => spot.y).reduce((max, y) => y > max ? y : max);

    // Add 20% extra space at the top
    return maxY * 1.2;
  }
}
