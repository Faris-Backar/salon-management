import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/categories_widget.dart';

class HomeScreenAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final ValueNotifier<String?> selectedCategoryUid;
  const HomeScreenAppbar({
    super.key,
    required this.selectedCategoryUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: Responsive.isDesktop() ? false : true,
      toolbarHeight: Responsive.isDesktop() ? kMinInteractiveDimension : null,
      backgroundColor: Theme.of(context).appBarTheme.surfaceTintColor,
      title: const Text('Home'),
      actions: [
        IconButton(
          onPressed: () => _showEmployeeSelectionDialog(context),
          icon: const Icon(Icons.person_rounded),
        ),
        Consumer(
          builder: (context, ref, child) {
            final cartState = ref.watch(cartNotifierProvider);
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Badge.count(
                count: cartState.selectedServices.length,
                child: const Icon(Icons.receipt_rounded),
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CategoriesWidget(selectedCategoryUid: selectedCategoryUid),
      ),
    );
  }

  void _showEmployeeSelectionDialog(BuildContext context) {
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
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return ListTile(
                        title: Text(employee.fullname),
                        subtitle:
                            Text("Specialisation: ${employee.specialisation}"),
                        onTap: () {
                          ref
                              .read(cartNotifierProvider.notifier)
                              .setEmployee(employee);
                          context.router.popForced();
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

  @override
  Size get preferredSize => Size.fromHeight(
        (kToolbarHeight) + 50.0,
      );
}
