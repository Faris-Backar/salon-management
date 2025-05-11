import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/settings/presentation/notifiers/expense/expense_notifier.dart';
import 'package:salon_management/app/feature/settings/presentation/notifiers/expense/expense_state.dart';
import 'package:salon_management/app/feature/widgets/text_input_form_field.dart';

@RoutePage()
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarksController = TextEditingController();
  EmployeeEntity? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(employeeNotifierProvider.notifier).fetchEmployee();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _showEmployeeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, child) {
          final employeeState = ref.watch(employeeNotifierProvider);

          return AlertDialog(
            title: const Text("Select an Employee"),
            content: employeeState.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              employeesFetched: (employees) {
                return SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.separated(
                    itemCount: employees.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return ListTile(
                        title: Text(employee.fullname),
                        subtitle: Text("Mobile : ${employee.mobile}"),
                        onTap: () {
                          setState(() {
                            _selectedEmployee = employee;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
              orElse: () => const Text("No employees available"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          );
        });
      },
    );
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate() && _selectedEmployee != null) {
      ref.read(expenseNotifierProvider.notifier).addExpense(
            amount: _amountController.text,
            remarks: _remarksController.text,
            employeeId: _selectedEmployee!.uid,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final employeeState = ref.watch(employeeNotifierProvider);
          final expenseState = ref.watch(expenseNotifierProvider);

          // Handle expense state
          ref.listen<ExpenseState>(expenseNotifierProvider,
              (previous, current) {
            if (current is ExpenseLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (current is ExpenseSuccess) {
              // Close any loading dialog and show success message
              Navigator.of(context, rootNavigator: true)
                  .pop(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense added successfully')),
              );
              Navigator.of(context).pop(); // Return to previous screen
            } else if (current is ExpenseFailure) {
              // Close any loading dialog and show error message
              Navigator.of(context, rootNavigator: true)
                  .pop(); // Close loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${current.message}')),
              );
            }
          });

          return employeeState.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: _showEmployeeSelectionDialog,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Employee',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        child: _selectedEmployee != null
                            ? Text(_selectedEmployee!.fullname)
                            : const Text(
                                'Select an employee',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                    ),
                    if (_selectedEmployee == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Text(
                          'Please select an employee',
                          style:
                              TextStyle(color: Colors.red[700], fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text("Amount", style: context.textTheme.titleMedium),
                    TextInputFormField(
                      controller: _amountController,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text("Remarks", style: context.textTheme.titleMedium),
                    TextInputFormField(
                      controller: _remarksController,
                      textInputType: TextInputType.text,
                      hint: "Remarks",
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter remarks';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          _selectedEmployee == null ? null : _submitExpense,
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
