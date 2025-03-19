import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/presentations/notifiers/get_transactions_by_customer_id.dart';

@RoutePage()
class CustomerDetailsScreen extends ConsumerStatefulWidget {
  const CustomerDetailsScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _employee;
  String? _serviceName;
  CustomerEntity? selectedCustomer;
  bool _showActiveFilters = false;

  // Lists for dropdown options
  List<String> employeeOptions = [];
  List<String> serviceOptions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        selectedCustomer =
            ref.read(customerNotifierProvider.notifier).selectedCustomer;
        if (selectedCustomer != null) {
          ref
              .read(transactionProvider.notifier)
              .fetchTransactionsByCustomerId(selectedCustomer!.uid);
        }

        _checkAndFetchEmployees();
        _checkAndFetchServiceItems();
      },
    );
  }

  void _checkAndFetchEmployees() {
    final employeeNotifier = ref.read(employeeNotifierProvider.notifier);
    if (employeeNotifier.employeeList.isEmpty) {
      employeeNotifier.fetchEmployee();
    } else {
      // If list is already populated, use it to set employee options
      setState(() {
        employeeOptions = employeeNotifier.employeeList
            .map((employee) => employee.fullname)
            .toList()
          ..sort();
      });
    }
  }

  void _checkAndFetchServiceItems() {
    final serviceItemNotifier = ref.read(serviceItemNotifierProvider.notifier);
    if (serviceItemNotifier.serviceItems.isEmpty) {
      serviceItemNotifier.fetchServiceItems();
    } else {
      setState(() {
        serviceOptions = serviceItemNotifier.serviceItems
            .map((service) => service.name)
            .cast<String>()
            .toList()
          ..sort();
      });
    }
  }

  List<TransactionEntity> _filteredTransactions(
      List<TransactionEntity> transactions) {
    return transactions.where((transaction) {
      if (_startDate != null && transaction.createdAt.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.createdAt.isAfter(_endDate!)) {
        return false;
      }
      if (_employee != null &&
          _employee!.isNotEmpty &&
          transaction.employee != _employee) {
        return false;
      }
      if (_serviceName != null && _serviceName!.isNotEmpty) {
        bool serviceFound = transaction.selectedServices.any((service) =>
            service.name.toLowerCase().contains(_serviceName!.toLowerCase()));
        if (!serviceFound) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _employee = null;
      _serviceName = null;
      _showActiveFilters = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final employeeState = ref.watch(employeeNotifierProvider.notifier);
    final serviceItemState = ref.watch(serviceItemNotifierProvider.notifier);
    final theme = Theme.of(context);

    if (employeeState.employeeList.isNotEmpty) {
      if (employeeOptions.isEmpty) {
        employeeOptions = employeeState.employeeList
            .map((employee) => employee.fullname)
            .toList()
          ..sort();
      }
    }

    if (serviceItemState.serviceItems.isNotEmpty) {
      if (serviceOptions.isEmpty) {
        serviceOptions = serviceItemState.serviceItems
            .map((service) => service.name)
            .cast<String>()
            .toList()
          ..sort();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (selectedCustomer != null) {
                ref
                    .read(transactionProvider.notifier)
                    .fetchTransactionsByCustomerId(selectedCustomer!.uid);
              }
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomerInfoCard(),
          if (_showActiveFilters) _buildActiveFilters(),
          Expanded(
            child: _buildTransactionList(transactionState, theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterDialog(),
        tooltip: 'Filter Transactions',
        child: Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Text(
                    selectedCustomer?.name.isNotEmpty == true
                        ? selectedCustomer!.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCustomer?.name ?? 'Customer Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Customer since ${selectedCustomer?.createdAt != null ? DateFormat('MMMM yyyy').format(selectedCustomer!.createdAt!) : 'N/A'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.phone, 'Phone',
                    selectedCustomer?.mobileNumber ?? 'N/A'),
                SizedBox(height: 12),
                _buildInfoRow(Icons.location_on, 'Address',
                    selectedCustomer?.address ?? 'N/A'),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 16),
                onPressed: _resetFilters,
                color: Colors.blue[800],
                tooltip: 'Clear All Filters',
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              if (_startDate != null)
                _buildFilterChip(
                    'From: ${DateFormat('MMM d, y').format(_startDate!)}'),
              if (_endDate != null)
                _buildFilterChip(
                    'To: ${DateFormat('MMM d, y').format(_endDate!)}'),
              if (_employee != null && _employee!.isNotEmpty)
                _buildFilterChip('Employee: $_employee'),
              if (_serviceName != null && _serviceName!.isNotEmpty)
                _buildFilterChip('Service: $_serviceName'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildTransactionList(transactionState, ThemeData theme) {
    if (transactionState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (transactionState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              transactionState.errorMessage!,
              style: TextStyle(color: Colors.red[300]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedCustomer != null) {
                  ref
                      .read(transactionProvider.notifier)
                      .fetchTransactionsByCustomerId(selectedCustomer!.uid);
                }
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (transactionState.transactions == null ||
        transactionState.transactions!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This customer hasn\'t made any purchases yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final filteredTransactions =
        _filteredTransactions(transactionState.transactions!);

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list, size: 64, color: Colors.amber[700]),
            SizedBox(height: 16),
            Text(
              'No matching transactions',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: _resetFilters,
              child: Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${filteredTransactions.length} ${filteredTransactions.length == 1 ? 'record' : 'records'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredTransactions.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return _buildTransactionCard(transaction, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionEntity transaction, ThemeData theme) {
    final totalServices = transaction.selectedServices.length;
    final mainService = transaction.selectedServices.first;
    final additionalServices = totalServices > 1 ? totalServices - 1 : 0;

    return InkWell(
      onTap: () => _showTransactionDetails(transaction),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.spa,
                color: theme.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainService.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        transaction.employee,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (additionalServices > 0) ...[
                        SizedBox(width: 12),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+$additionalServices more',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, y').format(transaction.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${transaction.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(TransactionEntity transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              _buildDetailItem('Transaction Date',
                  DateFormat('MMMM d, yyyy').format(transaction.createdAt)),
              _buildDetailItem('Transaction Time',
                  DateFormat('h:mm a').format(transaction.createdAt)),
              _buildDetailItem('Employee', transaction.employee),
              _buildDetailItem('Payment Method', transaction.paymentMethod),
              Divider(),
              Text(
                'Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: transaction.selectedServices.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final service = transaction.selectedServices[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(service.name),
                      trailing: Text('\$${service.price}'),
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '\$${transaction.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Share transaction details functionality
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.share),
                      label: Text('Share'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Print receipt functionality
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.print),
                      label: Text('Print'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    DateTime? fromDate = _startDate;
    DateTime? toDate = _endDate;
    String? selectedEmployee = _employee;
    String? selectedService = _serviceName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.filter,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // From Date Picker
              Row(
                children: [
                  Text('Start Date:'),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          fromDate = pickedDate;
                        });
                      }
                    },
                    child: Text(fromDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(fromDate!)),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // To Date Picker
              Row(
                children: [
                  Text('End Date:'),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          toDate = pickedDate;
                        });
                      }
                    },
                    child: Text(toDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(toDate!)),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Employee Text Field
              TextField(
                decoration: InputDecoration(labelText: 'Filter by Employee'),
                onChanged: (value) {
                  setState(() {
                    selectedEmployee = value.isEmpty ? null : value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Service Name Text Field
              TextField(
                decoration:
                    InputDecoration(labelText: 'Filter by Service Name'),
                onChanged: (value) {
                  setState(() {
                    selectedService = value.isEmpty ? null : value;
                  });
                },
              ),
              SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          fromDate = null;
                          toDate = null;
                          selectedEmployee = null;
                          selectedService = null;
                        });
                      },
                      child: Text('Clear Filters'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters
                        setState(() {
                          _startDate = fromDate;
                          _endDate = toDate;
                          _employee = selectedEmployee;
                          _serviceName = selectedService;
                          _showActiveFilters = _startDate != null ||
                              _endDate != null ||
                              (_employee != null && _employee!.isNotEmpty) ||
                              (_serviceName != null &&
                                  _serviceName!.isNotEmpty);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
