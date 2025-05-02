import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/billing_widget.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/categories_widget.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/employee_selection_widget.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/home_screen_appbar.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/service_item_grid_widget.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/side_bar_widget.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';

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
      endDrawer: Drawer(child: const BillingWidget()),
      body: !Responsive.isDesktop()
          ? ServiceItemGridWidget()
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
                                  CategoriesWidget(
                                    selectedCategoryUid: selectedCategoryUid,
                                  ),
                                  ServiceItemGridWidget(),
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
                                    child: EmployeeSelectionWidget(),
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
                Expanded(flex: 2, child: BillingWidget())
              ],
            ),
    );
  }
}
