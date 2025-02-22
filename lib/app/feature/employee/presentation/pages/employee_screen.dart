import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/core/utils/form_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_state.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _specialisedServiceController = TextEditingController();
  bool _isSameAddress = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                SizedBox(
                  height: 15.h,
                ),
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
                  label: AppStrings.currentAddress,
                  controller: _currentAddressController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Please enter a valid address";
                    }
                    return null;
                  },
                  maxLines: 6,
                  hint: AppStrings.currentAddress,
                ),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      value: _isSameAddress,
                      onChanged: (value) {
                        setState(() {
                          _isSameAddress = value ?? false;
                          if (_isSameAddress) {
                            _permanentAddressController.text =
                                _currentAddressController.text;
                          } else {
                            _permanentAddressController.clear();
                          }
                        });
                      },
                    ),
                    Text("Same as Current Address"),
                  ],
                ),
                CustomTextField(
                  label: AppStrings.permanentAddress,
                  maxLines: 6,
                  hint: AppStrings.permanentAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Please enter a valid address";
                    }
                    return null;
                  },
                  controller: _permanentAddressController,
                  enabled: !_isSameAddress,
                ),
                SizedBox(height: 10),
                CustomTextField(
                  label: AppStrings.specialisedService,
                  hint: AppStrings.specialisedService,
                  controller: _specialisedServiceController,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20),
                Consumer(builder: (context, ref, child) {
                  final employeeState = ref.read(employeeNotifierProvider);
                  ref.listen<EmployeeState>(employeeNotifierProvider,
                      (previous, next) {
                    next.maybeWhen(
                      failed: (message) {
                        AppUtils.showSnackBar(context,
                            content: message, isForErrorMessage: true);
                      },
                      createEmployeeSuccess: (user) {
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
                    child: employeeState.maybeMap(
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
                            final employeeDetails = EmployeeEntity(
                                uid: uid,
                                contactAddress: _currentAddressController.text,
                                permenentAddress:
                                    _permanentAddressController.text,
                                fullname: _nameController.text,
                                mobile: _mobileController.text,
                                specialisation:
                                    _specialisedServiceController.text);
                            log("here $employeeDetails");
                            ref
                                .read(employeeNotifierProvider.notifier)
                                .createEmployee(employee: employeeDetails);
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
    );
  }
}
