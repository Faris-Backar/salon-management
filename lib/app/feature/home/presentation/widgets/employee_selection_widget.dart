import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';

class EmployeeSelectionWidget extends ConsumerWidget {
  const EmployeeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeNotifierProvider);

    return employeeState.maybeWhen(
      employeesFetched: (employees) => GridView.builder(
        itemCount: employees.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final employee = employees[index];
          return InkWell(
            onTap: () {
              ref.read(cartNotifierProvider.notifier).setEmployee(employee);
            },
            child: Card(
              elevation: 5.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // Different color from services
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      employee.fullname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      employee.mobile,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      orElse: () => const Center(child: Text("No employees found")),
    );
  }
}
