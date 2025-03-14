import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';

import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';

class HomeScreenAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final ValueNotifier<String?> selectedCategoryUid;
  const HomeScreenAppbar({
    super.key,
    required this.selectedCategoryUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.read(categoryNotifierProvider);
    return AppBar(
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
        child: categoriesState.maybeWhen(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          categoryFetched: (categoryList) {
            return ValueListenableBuilder<String?>(
              valueListenable: selectedCategoryUid,
              builder: (context, selectedUid, child) {
                final allCategory = categoryList.firstWhere(
                  (category) => category.name.toLowerCase() == "all",
                  orElse: () => categoryList.first,
                );
                selectedCategoryUid.value ??= allCategory.uid;

                return Container(
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      final category = categoryList[index];
                      final isSelected = selectedUid == category.uid;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            selectedCategoryUid.value = category.uid;

                            ref
                                .read(serviceItemNotifierProvider.notifier)
                                .fetchServiceItemsBasedonCategory(
                                  categoryUid: category.uid,
                                  isForAll:
                                      category.name.toLowerCase() == "all",
                                );
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.2)
                                  : context.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(category.name),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          orElse: () {
            return Center(child: Text("Something went wrong."));
          },
        ),
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
