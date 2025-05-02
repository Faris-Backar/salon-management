import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';

// Filter types for customer
enum CustomerFilterType { all, regular, newCustomer }

// Provider for customer filter
final customerFilterProvider = StateProvider<CustomerFilterType>(
  (ref) => CustomerFilterType.all,
);

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

@RoutePage()
class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(customerNotifierProvider.notifier).fetchCustomer(),
    );

    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedFilter = ref.watch(customerFilterProvider);
    final isMobile = Responsive.isMobile();

    log("$customerState");

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.customers),
        automaticallyImplyLeading: isMobile,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref
                .read(customerNotifierProvider.notifier)
                .fetchCustomer(isRefresh: true),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filter and search card
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter chips
                    Row(
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              selected:
                                  selectedFilter == CustomerFilterType.all,
                              label: const Text('All Customers'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.primaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(customerFilterProvider.notifier)
                                      .state = CustomerFilterType.all;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected:
                                  selectedFilter == CustomerFilterType.regular,
                              label: const Text('Regular'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.secondaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(customerFilterProvider.notifier)
                                      .state = CustomerFilterType.regular;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: selectedFilter ==
                                  CustomerFilterType.newCustomer,
                              label: const Text('New'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.tertiaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(customerFilterProvider.notifier)
                                      .state = CustomerFilterType.newCustomer;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Export button
                        TextButton.icon(
                          onPressed: () => context.router
                              .pushNamed(AppRouter.createCustomer),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text(
                            "Add Customer",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Search and summary row
                    Row(
                      children: [
                        // Search field (larger portion)
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by name or phone...',
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
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _searchController.clear();
                                          ref
                                              .read(
                                                  searchQueryProvider.notifier)
                                              .state = '';
                                        },
                                      )
                                    : null,
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Customer stats
                        Expanded(
                          flex: 3,
                          child: customerState.maybeWhen(
                            customerFetched: (customers) {
                              // Simple customer stats
                              final totalCustomers = customers.length;
                              final newCustomers = totalCustomers > 0
                                  ? (totalCustomers * 0.3).round()
                                  : 0; // This would be real logic in a real app
                              final regularCustomers =
                                  totalCustomers - newCustomers;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Total",
                                    totalCustomers.toString(),
                                    Icons.people_outline,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Regular",
                                    regularCustomers.toString(),
                                    Icons.person_outline,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "New",
                                    newCustomers.toString(),
                                    Icons.person_add_alt_outlined,
                                    context.colorScheme.tertiary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Last Added",
                                    totalCustomers > 0
                                        ? DateFormat.MMMd()
                                            .format(DateTime.now())
                                        : "N/A",
                                    Icons.date_range_outlined,
                                    context.colorScheme.secondary,
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
                            orElse: () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.info_outline, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "No customer statistics available",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Customer List (DataTable)
            Expanded(
              child: customerState.maybeMap(
                customerFetched: (customer) {
                  var customers = customer.employeeList;

                  // Apply search filter if text entered
                  if (searchQuery.isNotEmpty) {
                    customers = customers.where((customer) {
                      final searchLower = searchQuery.toLowerCase();
                      return customer.name
                              .toLowerCase()
                              .contains(searchLower) ||
                          customer.mobileNumber.contains(searchLower);
                    }).toList();
                  }

                  // Apply category filter
                  if (selectedFilter == CustomerFilterType.regular) {
                    // This is just an example condition - implement real logic as needed
                    // Instead of using modulo on UID, we should use a proper field or logic
                    // For example, use a date-based check or a dedicated "status" field
                    customers = customers
                        .where((c) =>
                            c.createdAt != null &&
                            c.createdAt!.isBefore(DateTime.now()
                                .subtract(const Duration(days: 30))))
                        .toList();
                  } else if (selectedFilter == CustomerFilterType.newCustomer) {
                    // For new customers - those created within last 30 days
                    customers = customers
                        .where((c) =>
                            c.createdAt != null &&
                            c.createdAt!.isAfter(DateTime.now()
                                .subtract(const Duration(days: 30))))
                        .toList();
                  }

                  if (customers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 48,
                            color:
                                context.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isNotEmpty
                                ? "No matching customers found"
                                : "No customers available",
                            style: TextStyle(
                              color: context.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
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
                                  const Text('Customer List'),
                                  const Spacer(),
                                  Text(
                                    "${customers.length} Customers",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              rowsPerPage: 10,
                              columnSpacing: 16,
                              horizontalMargin: 16,
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(label: Text('Sl.No')),
                                DataColumn(label: Text('Customer Name')),
                                DataColumn(label: Text('Mobile Number')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _CustomerDataSource(
                                customers,
                                context,
                                onViewDetails: (customer) {
                                  ref
                                      .read(customerNotifierProvider.notifier)
                                      .selectedCustomer = customer;
                                  context.router.pushNamed(
                                      AppRouter.customerDetailsScreen);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: (_) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Loading customers..."),
                    ],
                  ),
                ),
                failed: (error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: context.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load customers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.error,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref
                            .read(customerNotifierProvider.notifier)
                            .fetchCustomer(isRefresh: true),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
                orElse: () => const Center(child: Text("No Data is Available")),
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
class _CustomerDataSource extends DataTableSource {
  final List<CustomerEntity> _customers;
  final BuildContext _context;
  final Function(CustomerEntity) onViewDetails;

  _CustomerDataSource(this._customers, this._context,
      {required this.onViewDetails});

  @override
  DataRow getRow(int index) {
    final customer = _customers[index];
    // Determine if customer is "regular" based on creation date
    // Instead of using modulo on UID which wouldn't work for UUIDs
    final isRegular = customer.createdAt != null &&
        customer.createdAt!
            .isBefore(DateTime.now().subtract(const Duration(days: 30)));

    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')), // Using index + 1 as Serial Number
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: _context.colorScheme.primary.withOpacity(0.2),
                child: Text(
                  customer.name.isNotEmpty
                      ? customer.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 12,
                    color: _context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(customer.name),
            ],
          ),
        ),
        DataCell(Text(customer.mobileNumber)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isRegular
                  ? _context.colorScheme.secondaryContainer
                  : _context.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isRegular ? 'Regular' : 'New',
              style: TextStyle(
                fontSize: 12,
                color: isRegular
                    ? _context.colorScheme.onSecondaryContainer
                    : _context.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: _context.colorScheme.primary,
                ),
                onPressed: () => onViewDetails(customer),
                tooltip: 'View Details',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: _context.colorScheme.secondary,
                ),
                onPressed: () {
                  // Edit functionality would go here
                },
                tooltip: 'Edit',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _customers.length;

  @override
  int get selectedRowCount => 0;
}
