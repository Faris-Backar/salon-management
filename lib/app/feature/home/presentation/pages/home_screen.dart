// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:uuid/uuid.dart';

import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_state.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_state.dart';
import 'package:salon_management/app/feature/cart/presentation/widgets/bill_section.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/home_screen_appbar.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/side_bar_widget.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/gen/assets.gen.dart';

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
    final serviceItemsState = ref.watch(serviceItemNotifierProvider);
    final cartState = ref.watch(cartNotifierProvider);

    final categoriesState = ref.read(categoryNotifierProvider);

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
                      final cartNotifier =
                          ref.read(cartNotifierProvider.notifier);

                      cartNotifier.clearCart();
                      context.router.popForced();
                      context.router.popForced();
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
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
      appBar: Responsive.isDesktop()
          ? null
          : HomeScreenAppbar(
              selectedCategoryUid: selectedCategoryUid,
            ),
      drawer: Responsive.isMobile()
          ? SidebarWidget(
              isExpanded: true,
              onToggleExpand: () {},
            )
          : null,
      endDrawer: Drawer(child: _buildBillWidget(cartState: cartState)),
      body: !Responsive.isDesktop()
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
                  flex: 6,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppStrings.home,
                            style: context.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  categoriesState.maybeWhen(
                                    initial: () => const SizedBox.shrink(),
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                    categoryFetched: (categoryList) {
                                      return ValueListenableBuilder<String?>(
                                        valueListenable: selectedCategoryUid,
                                        builder: (context, selectedUid, child) {
                                          final allCategory =
                                              categoryList.firstWhere(
                                            (category) =>
                                                category.name.toLowerCase() ==
                                                "all",
                                            orElse: () => categoryList.first,
                                          );
                                          selectedCategoryUid.value ??=
                                              allCategory.uid;

                                          return Container(
                                            height: 50.0,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: categoryList.length,
                                              itemBuilder: (context, index) {
                                                final category =
                                                    categoryList[index];
                                                final isSelected =
                                                    selectedUid == category.uid;

                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      selectedCategoryUid
                                                          .value = category.uid;

                                                      ref
                                                          .read(
                                                              serviceItemNotifierProvider
                                                                  .notifier)
                                                          .fetchServiceItemsBasedonCategory(
                                                            categoryUid:
                                                                category.uid,
                                                            isForAll: category
                                                                    .name
                                                                    .toLowerCase() ==
                                                                "all",
                                                          );
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withValues(
                                                                    alpha: 0.2)
                                                            : context
                                                                .colorScheme
                                                                .tertiaryContainer,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                              : Colors
                                                                  .transparent,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child:
                                                          Text(category.name),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    orElse: () => SizedBox.shrink(),
                                  ),
                                  serviceItemsState.maybeWhen(
                                    serviceItemsFetched: (serviceItems) =>
                                        GridView.builder(
                                      itemCount: serviceItems.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                      ),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            ref
                                                .read(cartNotifierProvider
                                                    .notifier)
                                                .addService(
                                                    serviceItems[index]);
                                          },
                                          child: Card(
                                            elevation: 5.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text('Service Name'),
                                                  Text(
                                                      '${AppStrings.indianRupee}100'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    orElse: () => const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      "Employees",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        final employeeState =
                                            ref.watch(employeeNotifierProvider);

                                        return employeeState.maybeWhen(
                                          employeesFetched: (employees) =>
                                              GridView.builder(
                                            itemCount: employees.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            itemBuilder: (context, index) {
                                              final employee = employees[index];
                                              return InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(cartNotifierProvider
                                                          .notifier)
                                                      .setEmployee(employee);
                                                },
                                                child: Card(
                                                  elevation: 5.0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .blue, // Different color from services
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          employee.fullname,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          employee.mobile,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white70),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          orElse: () => const Center(
                                              child:
                                                  Text("No employees found")),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: _buildBillWidget(cartState: cartState))
              ],
            ),
    );
  }

  _buildBillWidget({required CartState cartState}) {
    return BillSection(
      selectedServices: cartState.selectedServices,
      customerName: cartState.customer?.name ?? "Guest",
      customerPhoneNumber: cartState.customer?.mobileNumber ?? "N/A",
      employeeName: cartState.employee?.fullname ?? "Not Assigned",
      totalAmount: ref.read(cartNotifierProvider.notifier).totalAmount,
      onCheckout: (amount, paymentMethod) {
        final uid = const Uuid().v8();
        final bill = TransactionEntity(
          type: TransactionType.income,
          uid: uid,
          selectedServices: cartState.selectedServices,
          customer: cartState.customer,
          employee: cartState.employee,
          amount: amount,
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
    );
  }
}
