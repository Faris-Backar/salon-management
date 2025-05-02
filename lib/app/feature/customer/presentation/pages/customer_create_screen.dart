import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/core/utils/form_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_state.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CustomerCreateScreen extends StatefulWidget {
  const CustomerCreateScreen({super.key});

  @override
  State<CustomerCreateScreen> createState() => _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends State<CustomerCreateScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile()
          ? AppBar(
              title: Text(AppStrings.customers),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile() ? 8.0 : 32.0,
            vertical: 8.0,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (Responsive.isDesktop())
                    SizedBox(
                      height: 15.h,
                    ),
                  if (Responsive.isDesktop())
                    Row(
                      children: [
                        Text(
                          AppStrings.employees,
                          style: context.textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                  if (Responsive.isDesktop() || Responsive.isTablet())
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: AppStrings.fullName,
                            controller: _nameController,
                            hint: AppStrings.fullName,
                            validator: FormUtils.fullNameValidator,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomTextField(
                            label: AppStrings.mobileNumber,
                            controller: _mobileController,
                            validator: FormUtils.mobileNumberValidator,
                            textInputType: TextInputType.phone,
                            hint: AppStrings.mobileNumber,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        CustomTextField(
                          label: AppStrings.fullName,
                          controller: _nameController,
                          hint: AppStrings.fullName,
                          validator: FormUtils.fullNameValidator,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          label: AppStrings.mobileNumber,
                          controller: _mobileController,
                          validator: FormUtils.mobileNumberValidator,
                          textInputType: TextInputType.phone,
                          hint: AppStrings.mobileNumber,
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  CustomTextField(
                    label: AppStrings.address,
                    controller: _addressController,
                    hint: AppStrings.address,
                    // textInputAction: TextInputAction.done,
                    maxLines: 6,
                  ),
                  SizedBox(height: 20),
                  Consumer(builder: (context, ref, child) {
                    final customerState = ref.read(customerNotifierProvider);
                    ref.listen<CustomerState>(customerNotifierProvider,
                        (previous, next) {
                      next.maybeWhen(
                        failed: (message) {
                          AppUtils.showSnackBar(context,
                              content: message, isForErrorMessage: true);
                        },
                        createCustomeruccess: (user) {
                          context.back();
                          ref
                              .read(customerNotifierProvider.notifier)
                              .fetchCustomer();
                          AppUtils.showSnackBar(context,
                              content: AppStrings.customerCreatedSuccessfully,
                              isForErrorMessage: false);
                        },
                        orElse: () {},
                      );
                    });

                    return SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: customerState.maybeMap(
                        loading: (_) => PrimaryButton(
                            label: AppStrings.createEmployee,
                            isLoading: true,
                            onPressed: () {}),
                        orElse: () => PrimaryButton(
                          label: AppStrings.createEmployee,
                          isLoading: false,
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              final uid = Uuid().v8();
                              final customerEntity = CustomerEntity(
                                  uid: uid,
                                  address: _addressController.text,
                                  mobileNumber: _mobileController.text,
                                  name: _nameController.text);
                              ref
                                  .read(customerNotifierProvider.notifier)
                                  .createcustomer(customer: customerEntity);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
