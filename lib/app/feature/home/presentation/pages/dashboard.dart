import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/side_bar_widget.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late ValueNotifier<bool> sideBarExpansionNotifier;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    sideBarExpansionNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    sideBarExpansionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile()) _buildSidebarWithExpansion(),
          Expanded(child: AutoRouter()),
        ],
      ),
    );
  }

  Widget _buildSidebarWithExpansion() {
    return ValueListenableBuilder<bool>(
      valueListenable: sideBarExpansionNotifier,
      builder: (context, isExpanded, child) {
        return SidebarWidget(
          isExpanded: Responsive.isTablet() ? false : isExpanded,
          onToggleExpand: _toggleSidebarExpansion,
        );
      },
    );
  }

  // AppBar _buildAppBar(bool isDesktop) {
  //   return AppBar(
  //     leading: isDesktop
  //         ? AppBar(
  //             title: Text(AppStrings.dashBoard),
  //           )
  //         : IconButton(
  //             icon: const Icon(Icons.menu_rounded),
  //             onPressed: () => _scaffoldKey.currentState?.openDrawer(),
  //           ),
  //   );
  // }

  void _toggleSidebarExpansion() {
    sideBarExpansionNotifier.value = !sideBarExpansionNotifier.value;
  }
}
