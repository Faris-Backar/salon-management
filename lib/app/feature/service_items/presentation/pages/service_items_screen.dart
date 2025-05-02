import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.gr.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for active/inactive filter
final categoryFilterProvider = StateProvider<String>((ref) => 'all');

class ServiceDialog extends ConsumerStatefulWidget {
  final ServiceItemEntity? serviceItem;

  const ServiceDialog({this.serviceItem, super.key});

  @override
  ConsumerState<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends ConsumerState<ServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  final _enabledNotifier = ValueNotifier(true);
  final _selectedCategoryUid = ValueNotifier<String>("");
  final _selectedCategoryName = ValueNotifier<String>("No Category");

  @override
  void initState() {
    super.initState();
    if (widget.serviceItem != null) {
      final service = widget.serviceItem!;
      _nameController.text = service.name;
      _serviceChargeController.text = service.price;
      _enabledNotifier.value = service.isActive;
      _selectedCategoryUid.value = service.categoryUid;
      _selectedCategoryName.value = service.categoryName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceChargeController.dispose();
    _enabledNotifier.dispose();
    _selectedCategoryUid.dispose();
    _selectedCategoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryNotifierProvider);

    return AlertDialog(
      title: Text(widget.serviceItem == null ? 'Add Service' : 'Edit Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: AppStrings.serviceName,
                controller: _nameController,
                hint: AppStrings.serviceName,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Please enter a valid name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.serviceCharge,
                controller: _serviceChargeController,
                hint: AppStrings.serviceCharge,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid price";
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return "Price must be greater than 0.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              categoryState.when(
                initial: () => const CircularProgressIndicator(),
                loading: () => const CircularProgressIndicator(),
                categoryFetched: (categories) {
                  return ValueListenableBuilder<String>(
                    valueListenable: _selectedCategoryUid,
                    builder: (context, selectedValue, child) {
                      return DropdownButtonFormField<String>(
                        value: selectedValue.isEmpty
                            ? widget.serviceItem?.categoryUid ?? ""
                            : selectedValue,
                        items: [
                          const DropdownMenuItem<String>(
                            value: "",
                            child: Text("No Category"),
                          ),
                          ...categories.map(
                            (category) => DropdownMenuItem<String>(
                              value: category.uid,
                              child: Text(category.name),
                            ),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Select Category",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _selectedCategoryUid.value = value ?? "";
                          if (value != null && value.isNotEmpty) {
                            final category = categories.firstWhere(
                              (cat) => cat.uid == value,
                              orElse: () => CategoryEntity(
                                uid: "",
                                name: "No Category",
                                isActive: true,
                              ),
                            );
                            _selectedCategoryName.value = category.name;
                          } else {
                            _selectedCategoryName.value = "No Category";
                          }
                        },
                      );
                    },
                  );
                },
                failed: (error) => Text("Failed to load categories: $error"),
                createCategorysuccess: (_) => const SizedBox(),
                updateCategorysuccess: (_) => const SizedBox(),
                deleteCategorysuccess: (_) => const SizedBox(),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: _enabledNotifier,
                builder: (context, isEnabled, child) {
                  return SwitchListTile(
                    title: const Text('Active'),
                    value: isEnabled,
                    onChanged: (value) => _enabledNotifier.value = value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final uid = widget.serviceItem?.uid ?? const Uuid().v8();
              final service = ServiceItemEntity(
                uid: uid,
                name: _nameController.text,
                isActive: _enabledNotifier.value,
                price: double.parse(_serviceChargeController.text)
                    .toStringAsFixed(2),
                categoryName: _selectedCategoryName.value,
                categoryUid: _selectedCategoryUid.value,
              );

              if (widget.serviceItem == null) {
                ref
                    .read(serviceItemNotifierProvider.notifier)
                    .createServiceItems(serviceItems: service);
              } else {
                ref
                    .read(serviceItemNotifierProvider.notifier)
                    .updateServiceItems(serviceItems: service);
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.serviceItem == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}

@RoutePage()
class ServiceItemsScreen extends ConsumerStatefulWidget {
  const ServiceItemsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceItemsScreenState();
}

class _ServiceItemsScreenState extends ConsumerState<ServiceItemsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serviceItemNotifierProvider.notifier).fetchServiceItems();
      ref.read(categoryNotifierProvider.notifier).fetchCategoriesItems();
    });
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
    final state = ref.watch(serviceItemNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filterType = ref.watch(categoryFilterProvider);
    final isMobile = Responsive.isMobile();

    ref.listen(serviceItemNotifierProvider, (previous, next) {
      next.maybeWhen(
        failed: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        createServiceItemsuccess: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.serviceItemCreatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
          ref.read(serviceItemNotifierProvider.notifier).fetchServiceItems();
        },
        updateServiceItemsuccess: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.serviceItemUpdatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
          ref.read(serviceItemNotifierProvider.notifier).fetchServiceItems();
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.services),
        automaticallyImplyLeading: isMobile,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: context.colorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ServiceDialog(),
          );
        },
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
                                hintText: 'Search services...',
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
                            serviceItemsFetched: (services) {
                              final activeServices = services
                                  .where((service) => service.isActive)
                                  .length;
                              final inactiveServices = services
                                  .where((service) => !service.isActive)
                                  .length;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Total Services",
                                    services.length.toString(),
                                    Icons.spa_outlined,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Active",
                                    activeServices.toString(),
                                    Icons.check_circle_outline,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Inactive",
                                    inactiveServices.toString(),
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

            // Services Table
            Expanded(
              child: state.maybeWhen(
                initial: () =>
                    const Center(child: Text("Welcome! Fetching services...")),
                loading: () => const Center(child: CircularProgressIndicator()),
                serviceItemsFetched: (services) {
                  if (services.isEmpty) {
                    return const Center(child: Text("No services found."));
                  }

                  // Filter services based on search and filter type
                  var filteredServices = services.where((service) {
                    final matchesSearch = searchQuery.isEmpty ||
                        service.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        service.categoryName
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                    final matchesFilter = filterType == 'all' ||
                        (filterType == 'active' && service.isActive) ||
                        (filterType == 'inactive' && !service.isActive);
                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filteredServices.isEmpty) {
                    return const Center(
                        child: Text("No matching services found."));
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
                              header: const Text('Service Records'),
                              rowsPerPage: 10,
                              columnSpacing: 12,
                              horizontalMargin: 16,
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(label: Text('Sl.No')),
                                DataColumn(label: Text('Service Name')),
                                DataColumn(label: Text('Category')),
                                DataColumn(label: Text('Price'), numeric: true),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              source: _ServiceDataSource(
                                filteredServices,
                                context,
                                onEdit: (service) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ServiceDialog(serviceItem: service),
                                  );
                                },
                                onStatusChange: (service) async {
                                  final newStatus = !service.isActive;
                                  final shouldChange = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(newStatus
                                            ? 'Activate Service'
                                            : 'Deactivate Service'),
                                        content: Text(
                                            'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} this service?'),
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
                                    final serviceUpdated = ServiceItemEntity(
                                      uid: service.uid,
                                      name: service.name,
                                      price: service.price,
                                      categoryName: service.categoryName,
                                      categoryUid: service.categoryUid,
                                      isActive: newStatus,
                                      remark: service.remark,
                                    );
                                    ref
                                        .read(serviceItemNotifierProvider
                                            .notifier)
                                        .updateServiceItems(
                                            serviceItems: serviceUpdated);
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

class _ServiceDataSource extends DataTableSource {
  final List<ServiceItemEntity> _services;
  final BuildContext context;
  final Function(ServiceItemEntity) onEdit;
  final Function(ServiceItemEntity) onStatusChange;

  _ServiceDataSource(
    this._services,
    this.context, {
    required this.onEdit,
    required this.onStatusChange,
  });

  @override
  DataRow getRow(int index) {
    final service = _services[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(service.name)),
        DataCell(Text(service.categoryName)),
        DataCell(Text('₹${service.price}')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: service.isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              service.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: service.isActive
                    ? context.colorScheme.onSecondaryContainer
                    : context.colorScheme.onErrorContainer,
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ServiceDialog(serviceItem: service),
                  );
                },
                tooltip: 'Edit Service',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(
                  service.isActive ? Icons.block : Icons.check_circle,
                  size: 20,
                  color: service.isActive ? Colors.red : Colors.green,
                ),
                onPressed: () => onStatusChange(service),
                tooltip: service.isActive ? 'Deactivate' : 'Activate',
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
  int get rowCount => _services.length;

  @override
  int get selectedRowCount => 0;
}
