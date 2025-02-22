import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_state.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CreateServiceItemScreen extends ConsumerStatefulWidget {
  const CreateServiceItemScreen({super.key});

  @override
  ConsumerState<CreateServiceItemScreen> createState() =>
      _CreateServiceItemScreenState();
}

class _CreateServiceItemScreenState
    extends ConsumerState<CreateServiceItemScreen> {
  final _nameController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  final _enabledNotifier = ValueNotifier(true);
  final _selectedCategoryUid = ValueNotifier<String>("");
  final _selectedCategoryName = ValueNotifier<String>("No Category");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryNotifierProvider.notifier).fetchCategoriesItems();
    });
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
    final serviceItemState = ref.watch(serviceItemNotifierProvider);

    ref.listen<ServiceItemState>(serviceItemNotifierProvider, (previous, next) {
      next.maybeWhen(
        failed: (message) {
          AppUtils.showSnackBar(context,
              content: message, isForErrorMessage: true);
        },
        createServiceItemsuccess: (user) {
          ref.read(serviceItemNotifierProvider.notifier).fetchServiceItems();
          context.back();
          AppUtils.showSnackBar(
            context,
            content: AppStrings.employeeCreatedSuccess,
            isForErrorMessage: false,
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: Responsive.isDesktop()
          ? null
          : AppBar(
              title: Text(AppStrings.addService),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              SizedBox(height: 15.h),
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
              SizedBox(height: 20.h),
              categoryState.when(
                initial: () => const CircularProgressIndicator(),
                loading: () => const CircularProgressIndicator(),
                categoryFetched: (categories) {
                  final dropdownItems = [
                    DropdownMenuItem<String>(
                      value: "",
                      child: Text("No Category"),
                    ),
                    ...categories.map(
                      (category) => DropdownMenuItem<String>(
                        value: category.uid,
                        child: Text(category.name),
                      ),
                    ),
                  ];

                  return ValueListenableBuilder<String>(
                    valueListenable: _selectedCategoryUid,
                    builder: (context, selectedValue, child) {
                      return DropdownButtonFormField<String>(
                        value: selectedValue,
                        items: dropdownItems,
                        borderRadius: BorderRadius.circular(5.0),
                        onChanged: (value) {
                          _selectedCategoryUid.value = value ?? "";
                          _selectedCategoryName.value = categories
                              .firstWhere(
                                (cat) => cat.uid == value,
                                orElse: () => CategoryEntity(
                                  uid: "",
                                  name: "No Category",
                                  isActive: true,
                                ),
                              )
                              .name;
                        },
                        decoration: const InputDecoration(
                          labelText: "Select Category",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                        ),
                      );
                    },
                  );
                },
                failed: (error) => Text("Failed to load categories: $error"),
                createCategorysuccess: (_) => const SizedBox(),
                updateCategorysuccess: (_) => const SizedBox(),
                deleteCategorysuccess: (_) => const SizedBox(),
              ),
              SizedBox(height: 15.h),
              ValueListenableBuilder<bool>(
                valueListenable: _enabledNotifier,
                builder: (context, enabled, child) {
                  return CheckboxListTile(
                    value: enabled,
                    onChanged: (value) {
                      _enabledNotifier.value = value ?? false;
                    },
                    title: Text(AppStrings.isActive),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        width: double.infinity,
        child: serviceItemState.maybeMap(
          loading: (_) => PrimaryButton(
            label: AppStrings.createEmployee,
            isLoading: true,
            onPressed: () {},
          ),
          orElse: () => PrimaryButton(
            label: AppStrings.addService,
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                final uid = const Uuid().v8();
                final service = ServiceItemEntity(
                  uid: uid,
                  name: _nameController.text,
                  isActive: _enabledNotifier.value,
                  price: double.parse(_serviceChargeController.text)
                      .toStringAsFixed(2),
                  categoryName: _selectedCategoryName.value,
                  categoryUid: _selectedCategoryUid.value,
                );

                ref
                    .read(serviceItemNotifierProvider.notifier)
                    .createServiceItems(serviceItems: service);
              }
            },
          ),
        ),
      ),
    );
  }
}
