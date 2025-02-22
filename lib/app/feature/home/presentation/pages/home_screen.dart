// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/cart/domain/entities/bill_entities.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_state.dart';
import 'package:salon_management/app/feature/cart/presentation/widgets/bill_section.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/side_bar_widget.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/gen/assets.gen.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ValueNotifier<String?> selectedCategoryUid =
      ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryNotifierProvider.notifier).fetchCategoriesItems();
      ref.read(serviceItemNotifierProvider.notifier).fetchServiceItems();
      ref.read(employeeNotifierProvider.notifier).fetchEmployee();
    });
  }

  @override
  void dispose() {
    selectedCategoryUid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoryNotifierProvider);
    final serviceItemsState = ref.watch(serviceItemNotifierProvider);
    final cartState = ref.watch(cartNotifierProvider);

    ref.listen<CheckoutState>(checkoutNotifierProvider, (previous, next) {
      next.maybeWhen(
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
        failure: (error) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Checkout Failed"),
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        success: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Checkout Successful"),
                content:
                    const Text("The bill has been processed successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(cartNotifierProvider.notifier).clearCart();
                      context.router.popForced();
                      context.router.popForced();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
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
      ),
      drawer: Responsive.isMobile()
          ? SidebarWidget(
              isExpanded: true,
              onToggleExpand: () {},
            )
          : null,
      endDrawer: Drawer(
        child: BillSection(
          selectedServices: cartState.selectedServices,
          shopName: "Bellozee",
          shopLogo: Assets.images.logo.path,
          contactNumber: "+919087654321",
          email: "info@bellozee.com",
          address: "Some Address",
          slogan: "Thank you, visit again.",
          customerName: cartState.customer?.name ?? "Guest",
          customerPhoneNumber: cartState.customer?.mobileNumber ?? "N/A",
          employeeName: cartState.employee?.fullname ?? "Not Assigned",
          totalAmount: ref.read(cartNotifierProvider.notifier).totalAmount,
          onCheckout: (amount, paymentMethod) {
            final uid = const Uuid().v8();
            final bill = BillEntities(
              uid: uid,
              selectedServices: cartState.selectedServices,
              customer: cartState.customer,
              employee: cartState.employee,
              totalAmount: amount,
              discountAmount: 0.0,
              paymentMethod: paymentMethod,
              createdAt: DateTime.now(),
              modifiedAt: DateTime.now(),
            );
            ref.read(checkoutNotifierProvider.notifier).processCheckout(bill);
          },
          onClearBill: () {
            ref.read(cartNotifierProvider.notifier).clearCart();
          },
        ),
      ),
      body: Responsive.isMobile()
          ? serviceItemsState.maybeWhen(
              serviceItemsFetched: (serviceItems) => GridView.builder(
                itemCount: serviceItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ref
                          .read(cartNotifierProvider.notifier)
                          .addService(serviceItems[index]);
                    },
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              serviceItems[index].name,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${AppStrings.indianRupee}${serviceItems[index].price}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              orElse: () => const SizedBox.shrink(),
            )
          : Row(
              children: [
                Expanded(
                  child: serviceItemsState.maybeWhen(
                    serviceItemsFetched: (serviceItems) => GridView.builder(
                      itemCount: serviceItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Service Name'),
                                Text('${AppStrings.indianRupee}100'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
              ],
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
}
