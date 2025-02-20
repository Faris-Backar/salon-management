import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_state.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';

@RoutePage()
class CreateServiceItemScreen extends StatefulWidget {
  const CreateServiceItemScreen({super.key});

  @override
  State<CreateServiceItemScreen> createState() =>
      _CreateServiceItemScreenState();
}

class _CreateServiceItemScreenState extends State<CreateServiceItemScreen> {
  final _nameController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  final _enabledNotifer = ValueNotifier(true);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Please enter a valid name";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15.h,
              ),
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
              SizedBox(
                height: 15.h,
              ),
              ValueListenableBuilder(
                valueListenable: _enabledNotifer,
                builder: (context, bool enabled, child) {
                  return CheckboxMenuButton(
                    value: enabled,
                    onChanged: (value) {
                      _enabledNotifer.value = value ?? false;
                    },
                    child: Text(AppStrings.isActive),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 45,
      //   width: double.infinity,
      //   margin: const EdgeInsets.symmetric(vertical: 8.0),
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      //   child: PrimaryButton(
      //     label: AppStrings.addService,
      //     onPressed: () {
      //       if (_formKey.currentState?.validate() == true) {}
      //     },
      //   ),
      // ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final serviceItemState = ref.read(serviceItemNotifierProvider);
          ref.listen<ServiceItemState>(serviceItemNotifierProvider,
              (previous, next) {
            next.maybeWhen(
              failed: (message) {
                AppUtils.showSnackBar(context,
                    content: message, isForErrorMessage: true);
              },
              createServiceItemsuccess: (user) {
                context.back();
                AppUtils.showSnackBar(context,
                    content: AppStrings.employeeCreatedSuccess,
                    isForErrorMessage: false);
              },
              orElse: () {},
            );
          });

          return SizedBox(
            height: 50,
            width: double.infinity,
            child: serviceItemState.maybeMap(
              loading: (_) => PrimaryButton(
                  label: AppStrings.createEmployee,
                  isLoading: true,
                  onPressed: () {}),
              orElse: () => PrimaryButton(
                label: AppStrings.addService,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    // final uid = Uuid().v8();
                    // final service = ServiceItemEntity(
                    //   uid: uid,
                    //   name: _nameController.text,
                    //   isActive: _enabledNotifer.value,
                    //   price: int.parse(_serviceChargeController.text)
                    //       .toStringAsFixed(2),
                    // );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
