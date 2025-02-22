// sidebar_widget.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/widgets/svg_icon.dart';
import 'package:salon_management/gen/assets.gen.dart';

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
      AppStrings.title: AppStrings.employees,
      AppStrings.path: AppRouter.employeeScreen,
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
      AppStrings.path: AppRouter.employeeScreen,
    },
    {
      AppStrings.icon: Assets.icons.setting,
      AppStrings.title: AppStrings.settings,
      AppStrings.path: AppRouter.employeeScreen,
    },
  ];

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
          ...List.generate(options.length, (index) {
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
                  context.router.pushNamed(options[index][AppStrings.path]);
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.surfaceDim
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          child: SvgIcon(
                            icon: options[index][AppStrings.icon],
                            color: context.onSurfaceColor,
                          ),
                        ),
                      ),
                      if (widget.isExpanded) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(options[index][AppStrings.title],
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
