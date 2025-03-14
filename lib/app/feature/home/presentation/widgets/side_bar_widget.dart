// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/widgets/svg_icon.dart';
import 'package:salon_management/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarWidget extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const SidebarWidget({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  State<SidebarWidget> createState() => _SidebarState();
}

class _SidebarState extends State<SidebarWidget> {
  int selectedIndex = 0;
  int? hoveredIndex;

  final List<Map<String, dynamic>> options = [
    {
      AppStrings.icon: Assets.icons.home1,
      AppStrings.title: AppStrings.home,
      AppStrings.path: AppRouter.homeScreen,
    },
    {
      AppStrings.icon: Assets.icons.team,
      AppStrings.title: AppStrings.transactions,
      AppStrings.path: AppRouter.transactionScreen,
    },
    {
      AppStrings.icon: Assets.icons.team,
      AppStrings.title: AppStrings.employees,
      AppStrings.path: AppRouter.employeeScreen,
    },
    {
      AppStrings.icon: Assets.icons.team,
      AppStrings.title: AppStrings.customers,
      AppStrings.path: AppRouter.customerScreen,
    },
    {
      AppStrings.icon: Assets.icons.haircut,
      AppStrings.title: AppStrings.services,
      AppStrings.path: AppRouter.serviceScreen,
    },
    {
      AppStrings.icon: Assets.icons.category,
      AppStrings.title: AppStrings.categories,
      AppStrings.path: AppRouter.categoryScreen,
    },
    {
      AppStrings.icon: Assets.icons.report,
      AppStrings.title: AppStrings.reports,
      AppStrings.path: AppRouter.reportScreen,
    },
    {
      AppStrings.icon: Assets.icons.setting,
      AppStrings.title: AppStrings.settings,
      AppStrings.path: AppRouter.employeeScreen,
    },
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      context.router.replaceNamed(AppRouter.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isExpanded
          ? Responsive.isMobile()
              ? 0.7.sw
              : 200
          : Responsive.isTablet()
              ? 50
              : 80,
      color: context.colorScheme.surfaceDim,
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onToggleExpand,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              child: Image.asset(Assets.images.logo.path),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final isHovered = hoveredIndex == index;
                final isSelected = selectedIndex == index;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = null),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      // if (!Responsive.isDesktop()) {
                      //   context.router.popForced();
                      // }
                      context.router.pushNamed(options[index][AppStrings.path]);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colorScheme.primary
                            : isHovered
                                ? Colors.grey[400]
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: SvgIcon(
                                icon: options[index][AppStrings.icon],
                                color: isSelected
                                    ? context.colorScheme.onPrimary
                                    : context.onSurfaceColor,
                              ),
                            ),
                          ),
                          if (widget.isExpanded) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                options[index][AppStrings.title],
                                style: context.textTheme.bodyLarge?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  color: isSelected
                                      ? context.colorScheme.onPrimary
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: _logout,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgIcon(
                            icon: Assets.icons.logout, color: Colors.white)),
                    if (widget.isExpanded) ...[
                      const SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
