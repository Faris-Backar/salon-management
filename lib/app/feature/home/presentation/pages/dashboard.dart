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
    final isDesktop = Responsive.isDesktop();

    return Scaffold(
      key: _scaffoldKey,
      appBar: isDesktop ? null : _buildAppBar(isDesktop),
      drawer: isDesktop ? null : Drawer(child: _buildSidebar(true)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) _buildSidebarWithExpansion(),
          Expanded(
            flex: isDesktop ? 7 : 1,
            child: Column(
              children: [
                if (isDesktop) _buildAppBar(isDesktop),
                Expanded(child: AutoRouter()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the sidebar with expansion toggle.
  Widget _buildSidebarWithExpansion() {
    return ValueListenableBuilder<bool>(
      valueListenable: sideBarExpansionNotifier,
      builder: (context, isExpanded, child) {
        return SidebarWidget(
          isExpanded: isExpanded,
          onToggleExpand: _toggleSidebarExpansion,
        );
      },
    );
  }

  /// Sidebar widget logic
  Widget _buildSidebar(bool isExpanded) {
    return SidebarWidget(
      isExpanded: isExpanded,
      onToggleExpand: () {},
    );
  }

  /// Builds the app bar.
  AppBar _buildAppBar(bool isDesktop) {
    return AppBar(
      leading: isDesktop
          ? ValueListenableBuilder<bool>(
              valueListenable: sideBarExpansionNotifier,
              builder: (context, isExpanded, child) {
                return IconButton(
                  icon: Icon(
                    isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  ),
                  onPressed: _toggleSidebarExpansion,
                );
              },
            )
          : IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
    );
  }

  void _toggleSidebarExpansion() {
    sideBarExpansionNotifier.value = !sideBarExpansionNotifier.value;
  }
}
