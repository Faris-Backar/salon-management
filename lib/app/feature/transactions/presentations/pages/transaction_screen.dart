// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/presentations/notifiers/transaction_notifiers.dart';

// New provider for selected transaction type filter
enum TransactionFilterType { all, income, expense }

final transactionFilterProvider = StateProvider<TransactionFilterType>(
  (ref) => TransactionFilterType.all,
);

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

@RoutePage()
class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  Future<void> _selectDate(
      BuildContext context, WidgetRef ref, bool isFromDate) async {
    final current = ref.read(isFromDate ? fromDateProvider : toDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      ref
          .read(
              isFromDate ? fromDateProvider.notifier : toDateProvider.notifier)
          .state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final totalAmount = ref.watch(filteredTotalAmountProvider);
    final fromDate = ref.watch(fromDateProvider);
    final toDate = ref.watch(toDateProvider);
    final selectedFilter = ref.watch(transactionFilterProvider);
    final isMobile = Responsive.isMobile();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        automaticallyImplyLeading: isMobile,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Compact header with filters and summary
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter row (chips and date pickers)
                    Row(
                      children: [
                        // Filter chips
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              selected:
                                  selectedFilter == TransactionFilterType.all,
                              label: const Text('All'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.primaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(transactionFilterProvider.notifier)
                                      .state = TransactionFilterType.all;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: selectedFilter ==
                                  TransactionFilterType.income,
                              label: const Text('Income'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.secondaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(transactionFilterProvider.notifier)
                                      .state = TransactionFilterType.income;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: selectedFilter ==
                                  TransactionFilterType.expense,
                              label: const Text('Expense'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor: context.colorScheme.errorContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(transactionFilterProvider.notifier)
                                      .state = TransactionFilterType.expense;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Date filters with compact display
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: () => _selectDate(context, ref, true),
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(
                                "From: ${DateFormat.MMMd().format(fromDate)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _selectDate(context, ref, false),
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(
                                "To: ${DateFormat.MMMd().format(toDate)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Search and summary in one row
                    Row(
                      children: [
                        // Search field
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by customer or employee...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: context.colorScheme.surfaceVariant
                                    .withOpacity(0.5),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                ref.read(searchQueryProvider.notifier).state =
                                    value;
                              },
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Summary stats in compact form
                        Expanded(
                          flex: 3,
                          child: transactionsAsync.when(
                            data: (transactions) {
                              final incomeTransactions = transactions
                                  .where((tx) => tx.isIncome)
                                  .toList();
                              final expenseTransactions = transactions
                                  .where((tx) => !tx.isIncome)
                                  .toList();

                              double incomeTotal = incomeTransactions.fold(
                                  0, (sum, tx) => sum + (tx.totalAmount ?? 0));
                              double expenseTotal = expenseTransactions.fold(
                                  0, (sum, tx) => sum + (tx.totalAmount ?? 0));

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Transactions",
                                    transactions.length.toString(),
                                    Icons.swap_horiz_outlined,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Income",
                                    "₹${incomeTotal.toStringAsFixed(0)}",
                                    Icons.arrow_upward_outlined,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Expense",
                                    "₹${expenseTotal.toStringAsFixed(0)}",
                                    Icons.arrow_downward_outlined,
                                    Colors.red,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Balance",
                                    "₹${(incomeTotal - expenseTotal).toStringAsFixed(0)}",
                                    Icons.account_balance_wallet_outlined,
                                    context.colorScheme.tertiary,
                                  ),
                                ],
                              );
                            },
                            loading: () => const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))),
                            error: (e, _) => Text("Error: $e",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // DataTable - Full width
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text("No Transactions Found"));
                  }

                  // Enhanced filter by search query (customer name, employee name)
                  final filteredTransactions = searchQuery.isEmpty
                      ? transactions
                      : transactions.where((tx) {
                          final searchLower = searchQuery.toLowerCase();

                          // Get string representations to search against
                          final customerString = tx.customer != null
                              ? tx.customer.toString().toLowerCase()
                              : "";
                          final employeeString = tx.employee != null
                              ? tx.employee.toString().toLowerCase()
                              : "";

                          return customerString.contains(searchLower) ||
                              employeeString.contains(searchLower);
                        }).toList();

                  if (filteredTransactions.isEmpty) {
                    return const Center(
                        child: Text("No matching transactions found"));
                  }

                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              header: Row(
                                children: [
                                  const Text('Transaction Records'),
                                  const Spacer(),
                                  Text(
                                    "Total: ₹${totalAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              rowsPerPage: 15,
                              columnSpacing:
                                  12, // Reduced spacing for more columns
                              horizontalMargin: 16,
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(label: Text('Sl.No')),
                                DataColumn(label: Text('Customer Name')),
                                DataColumn(label: Text('Mobile Number')),
                                DataColumn(label: Text('Employee Name')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Type')),
                                DataColumn(
                                    label: Text('Amount'), numeric: true),
                              ],
                              source: _TransactionDataSource(
                                  filteredTransactions
                                      as List<TransactionEntity>,
                                  context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// DataSource for the DataTable
class _TransactionDataSource extends DataTableSource {
  final List<TransactionEntity> _transactions;
  final BuildContext _context;

  _TransactionDataSource(this._transactions, this._context);

  @override
  DataRow getRow(int index) {
    final transaction = _transactions[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(transaction.customer != null
            ? transaction.customer!.name.toString()
            : "N/A")),
        DataCell(Text(transaction.customer != null
            ? transaction.customer!.mobileNumber.toString()
            : "N/A")),
        DataCell(Text(transaction.employee != null
            ? transaction.employee!.fullname.toString()
            : "N/A")),
        DataCell(Text(DateFormat.yMMMd().format(transaction.createdAt))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: transaction.isIncome ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              transaction.isIncome ? 'Income' : 'Expense',
              style: TextStyle(
                fontSize: 12,
                color: transaction.isIncome
                    ? _context.colorScheme.onSecondaryContainer
                    : _context.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            "₹${transaction.amount.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _transactions.length;

  @override
  int get selectedRowCount => 0;
}

// Add these providers to your transaction_notifiers.dart file
final filteredTransactionsProvider = Provider<AsyncValue<List>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  final filterType = ref.watch(transactionFilterProvider);

  return transactionsAsync.whenData((transactions) {
    if (filterType == TransactionFilterType.all) {
      return transactions;
    } else if (filterType == TransactionFilterType.income) {
      return transactions.where((tx) => tx.isIncome).toList();
    } else {
      return transactions.where((tx) => !tx.isIncome).toList();
    }
  });
});

final filteredTotalAmountProvider = Provider<double>((ref) {
  final transactionsAsync = ref.watch(filteredTransactionsProvider);

  return transactionsAsync.when(
    data: (transactions) {
      double total = 0.0;
      for (var tx in transactions) {
        total += tx.totalAmount ?? 0.0;
      }
      return total;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});
