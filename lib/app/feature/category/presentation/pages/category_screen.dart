import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/data/data/category.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for active/inactive filter
final categoryFilterProvider = StateProvider<String>((ref) => 'all');

@RoutePage()
class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(categoryNotifierProvider.notifier).fetchCategoriesItems());
  }

  Widget _buildCompactStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filterType = ref.watch(categoryFilterProvider);
    final isMobile = Responsive.isMobile();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.categories),
        automaticallyImplyLeading: isMobile,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: context.colorScheme.primary,
        onPressed: () =>
            context.router.pushNamed(AppRouter.createCategoryScreen),
        child: Icon(
          Icons.add_rounded,
          color: context.colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Compact header with filters and summary
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter row
                    Row(
                      children: [
                        // Filter chips
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              selected: filterType == 'all',
                              label: const Text('All'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.primaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(categoryFilterProvider.notifier)
                                      .state = 'all';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: filterType == 'active',
                              label: const Text('Active'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.secondaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(categoryFilterProvider.notifier)
                                      .state = 'active';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: filterType == 'inactive',
                              label: const Text('Inactive'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor: context.colorScheme.errorContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                      .read(categoryFilterProvider.notifier)
                                      .state = 'inactive';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Search and summary in one row
                    Row(
                      children: [
                        // Search field
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search categories...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: context.colorScheme.surfaceVariant
                                    .withOpacity(0.5),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                ref.read(searchQueryProvider.notifier).state =
                                    value;
                              },
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Summary stats in compact form
                        Expanded(
                          flex: 3,
                          child: state.maybeWhen(
                            categoryFetched: (employeeList) {
                              final activeCategories = employeeList
                                  .where((cat) => cat.isActive)
                                  .length;
                              final inactiveCategories = employeeList
                                  .where((cat) => !cat.isActive)
                                  .length;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Total Categories",
                                    employeeList.length.toString(),
                                    Icons.category_outlined,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Active",
                                    activeCategories.toString(),
                                    Icons.check_circle_outline,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Inactive",
                                    inactiveCategories.toString(),
                                    Icons.block_outlined,
                                    Colors.red,
                                  ),
                                ],
                              );
                            },
                            orElse: () => const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Categories Table
            Expanded(
              child: state.maybeWhen(
                initial: () => const Center(
                    child: Text("Welcome! Fetching categories...")),
                loading: () => const Center(child: CircularProgressIndicator()),
                categoryFetched: (employeeList) {
                  if (employeeList.isEmpty) {
                    return const Center(child: Text("No categories found."));
                  }

                  // Filter categories based on search and filter type
                  var filteredCategories = employeeList.where((category) {
                    final matchesSearch = searchQuery.isEmpty ||
                        category.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                    final matchesFilter = filterType == 'all' ||
                        (filterType == 'active' && category.isActive) ||
                        (filterType == 'inactive' && !category.isActive);
                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filteredCategories.isEmpty) {
                    return const Center(
                        child: Text("No matching categories found."));
                  }

                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              header: const Text('Category Records'),
                              rowsPerPage: 10,
                              columnSpacing: 12,
                              horizontalMargin: 16,
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(label: Text('Sl.No')),
                                DataColumn(label: Text('Category Name')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _CategoryDataSource(
                                filteredCategories,
                                context,
                                onEdit: (category) {
                                  context.router.pushNamed(
                                      AppRouter.createCategoryScreen);
                                },
                                onStatusChange: (category) async {
                                  final newStatus = !category.isActive;
                                  final shouldChange = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(newStatus
                                            ? 'Activate Category'
                                            : 'Deactivate Category'),
                                        content: Text(
                                            'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} this category?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Confirm'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldChange == true) {
                                    final categoryUpdated = Category(
                                      uid: category.uid,
                                      name: category.name,
                                      isActive: newStatus,
                                    );
                                    ref
                                        .read(categoryNotifierProvider.notifier)
                                        .updateCategoryItems(
                                            category: categoryUpdated);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                failed: (error) => Center(child: Text("Error: $error")),
                orElse: () =>
                    const Center(child: Text("Something went wrong.")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDataSource extends DataTableSource {
  final List<CategoryEntity> _categories;
  final BuildContext _context;
  final Function(CategoryEntity) onEdit;
  final Function(CategoryEntity) onStatusChange;

  _CategoryDataSource(this._categories, this._context,
      {required this.onEdit, required this.onStatusChange});

  @override
  DataRow getRow(int index) {
    final category = _categories[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(category.name)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: category.isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: category.isActive
                    ? _context.colorScheme.onSecondaryContainer
                    : _context.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => onEdit(category),
                tooltip: 'Edit Category',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(
                  category.isActive ? Icons.block : Icons.check_circle,
                  size: 20,
                  color: category.isActive ? Colors.red : Colors.green,
                ),
                onPressed: () => onStatusChange(category),
                tooltip: category.isActive ? 'Deactivate' : 'Activate',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _categories.length;

  @override
  int get selectedRowCount => 0;
}
