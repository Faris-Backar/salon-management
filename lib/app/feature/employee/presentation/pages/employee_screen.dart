import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';

// Filter types for employee
enum EmployeeFilterType { all, active, inactive }

// Provider for employee filter
final employeeFilterProvider = StateProvider<EmployeeFilterType>(
  (ref) => EmployeeFilterType.all,
);

// Provider for search query
final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

@RoutePage()
class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(employeeNotifierProvider.notifier).fetchEmployee(),
    );

    _searchController.addListener(() {
      ref.read(employeeSearchQueryProvider.notifier).state =
          _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeNotifierProvider);
    final searchQuery = ref.watch(employeeSearchQueryProvider);
    final selectedFilter = ref.watch(employeeFilterProvider);
    final isMobile = Responsive.isMobile();

    log("$employeeState");

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.employees),
        automaticallyImplyLeading: isMobile,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref
                .read(employeeNotifierProvider.notifier)
                .fetchEmployee(isRefresh: true),
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
                                  selectedFilter == EmployeeFilterType.all,
                              label: const Text('All Employees'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.primaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(employeeFilterProvider.notifier)
                                      .state = EmployeeFilterType.all;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected:
                                  selectedFilter == EmployeeFilterType.active,
                              label: const Text('Active'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.secondaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(employeeFilterProvider.notifier)
                                      .state = EmployeeFilterType.active;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected:
                                  selectedFilter == EmployeeFilterType.inactive,
                              label: const Text('Inactive'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.tertiaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(employeeFilterProvider.notifier)
                                      .state = EmployeeFilterType.inactive;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Add employee button
                        TextButton.icon(
                          onPressed: () => context.router
                              .pushNamed(AppRouter.createEmployee),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text(
                            "Add Employee",
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
                                hintText: 'Search by name, specialisation...',
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
                                              .read(employeeSearchQueryProvider
                                                  .notifier)
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

                        // Employee stats
                        Expanded(
                          flex: 3,
                          child: employeeState.maybeWhen(
                            employeesFetched: (employees) {
                              // Simple employee stats
                              final totalEmployees = employees.length;
                              final activeEmployees = totalEmployees > 0
                                  ? (totalEmployees * 0.7).round()
                                  : 0; // This would be real logic in a real app
                              final inactiveEmployees =
                                  totalEmployees - activeEmployees;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Total",
                                    totalEmployees.toString(),
                                    Icons.groups_outlined,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Active",
                                    activeEmployees.toString(),
                                    Icons.check_circle_outline,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Inactive",
                                    inactiveEmployees.toString(),
                                    Icons.cancel_outlined,
                                    Colors.red.shade400,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Last Added",
                                    totalEmployees > 0
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
                                  "No employee statistics available",
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

            // Employee List (DataTable)
            Expanded(
              child: employeeState.maybeMap(
                employeesFetched: (data) {
                  var employees = data.employeeList;

                  // Apply search filter if text entered
                  if (searchQuery.isNotEmpty) {
                    employees = employees.where((employee) {
                      final searchLower = searchQuery.toLowerCase();
                      return employee.fullname
                              .toLowerCase()
                              .contains(searchLower) ||
                          employee.mobile.contains(searchLower) ||
                          employee.specialisation
                              .toLowerCase()
                              .contains(searchLower);
                    }).toList();
                  }

                  // Apply category filter - in a real app, you would have an "active" field
                  // For this example we'll simulate based on UID
                  if (selectedFilter == EmployeeFilterType.active) {
                    // Simulation using UID character counts
                    employees =
                        employees.where((e) => e.uid.length % 2 == 0).toList();
                  } else if (selectedFilter == EmployeeFilterType.inactive) {
                    employees =
                        employees.where((e) => e.uid.length % 2 != 0).toList();
                  }

                  if (employees.isEmpty) {
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
                                ? "No matching employees found"
                                : "No employees available",
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
                                  const Text('Employee List'),
                                  const Spacer(),
                                  Text(
                                    "${employees.length} Employees",
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
                                DataColumn(label: Text('Employee Name')),
                                DataColumn(label: Text('Mobile')),
                                DataColumn(label: Text('Specialisation')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _EmployeeDataSource(
                                employees,
                                context,
                                onViewDetails: (employee) {
                                  // ref
                                  //     .read(employeeNotifierProvider.notifier)
                                  //     .selectedEmployee = employee;
                                  // context.router.pushNamed(
                                  //     AppRouter.employeeDetailsScreen);
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
                      Text("Loading employees..."),
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
                        'Failed to load employees',
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
                            .read(employeeNotifierProvider.notifier)
                            .fetchEmployee(isRefresh: true),
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
class _EmployeeDataSource extends DataTableSource {
  final List<EmployeeEntity> _employees;
  final BuildContext _context;
  final Function(EmployeeEntity) onViewDetails;

  _EmployeeDataSource(this._employees, this._context,
      {required this.onViewDetails});

  @override
  DataRow getRow(int index) {
    final employee = _employees[index];
    // Determine if employee is "active" based on UID (just for example)
    // In a real app, you would use a proper status field
    final isActive = employee.uid.length % 2 == 0; // Example condition

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
                  employee.fullname.isNotEmpty
                      ? employee.fullname[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 12,
                    color: _context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(employee.fullname),
            ],
          ),
        ),
        DataCell(Text(employee.mobile)),
        DataCell(Text(employee.specialisation)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green.shade700 : Colors.red.shade700,
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
                onPressed: () => onViewDetails(employee),
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
              IconButton(
                icon: Icon(
                  isActive ? Icons.block_outlined : Icons.check_circle_outline,
                  size: 18,
                  color: isActive ? Colors.red.shade400 : Colors.green,
                ),
                onPressed: () {
                  // Toggle active status functionality would go here
                },
                tooltip: isActive ? 'Deactivate' : 'Activate',
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
  int get rowCount => _employees.length;

  @override
  int get selectedRowCount => 0;
}
