// sidebar_widget.dart

import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
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
      AppStrings.icon: Icons.home_rounded,
      AppStrings.title: AppStrings.home,
      // AppStrings.path: PageResources.homeNested
    },
    {
      AppStrings.icon: Icons.school_rounded,
      AppStrings.title: AppStrings.employees,
      // AppStrings.path: PageResources.students
    },
    {
      AppStrings.icon: Icons.campaign_rounded,
      AppStrings.title: AppStrings.reports,
      // AppStrings.path: PageResources.campaign
    },
    // {
    //   AppStrings.icon: Icons.settings,
    //   AppStrings.title: AppStrings.admin,
    //   AppStrings.route: PageResources.admin
    // },
    {
      AppStrings.icon: Icons.settings_rounded,
      AppStrings.title: AppStrings.settings,
      // AppStrings.route: PageResources.settings
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isExpanded ? 200 : 80,
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Image.asset(Assets.images.logo.path),
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
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.surfaceDim
                        : isHovered
                            ? Colors.grey[400]
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        options[index][AppStrings.icon],
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
