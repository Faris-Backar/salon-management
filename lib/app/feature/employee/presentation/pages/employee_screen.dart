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
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile();

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              leading: IconButton(
                  onPressed: () => context.router.back(),
                  icon: Icon(Icons.adaptive.arrow_back)),
              title: Text(AppStrings.employees),
              elevation: 0,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 32.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile) ...[
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Icon(Icons.people,
                          size: 28, color: theme.colorScheme.primary),
                      SizedBox(width: 12.w),
                      Text(
                        AppStrings.employees,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Add new employee details",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Main form content in a card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          Text(
                            "Personal Information",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(height: 32),

                          // Personal info fields
                          if (Responsive.isDesktop() || Responsive.isTablet())
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _nameController,
                                    label: AppStrings.fullName,
                                    hint: "Enter employee's full name",
                                    icon: Icons.person_outline,
                                    validator: FormUtils.fullNameValidator,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _mobileController,
                                    label: AppStrings.mobileNumber,
                                    hint: "Enter contact number",
                                    icon: Icons.phone_outlined,
                                    validator: FormUtils.mobileNumberValidator,
                                    textInputType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildTextField(
                                  controller: _nameController,
                                  label: AppStrings.fullName,
                                  hint: "Enter employee's full name",
                                  icon: Icons.person_outline,
                                  validator: FormUtils.fullNameValidator,
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _mobileController,
                                  label: AppStrings.mobileNumber,
                                  hint: "Enter contact number",
                                  icon: Icons.phone_outlined,
                                  validator: FormUtils.mobileNumberValidator,
                                  textInputType: TextInputType.phone,
                                ),
                              ],
                            ),

                          SizedBox(height: 24),

                          // Specialization section
                          _buildTextField(
                            controller: _specialisedServiceController,
                            label: AppStrings.specialisedService,
                            hint: "Enter employee's specialization",
                            icon: Icons.star_outline,
                            textInputAction: TextInputAction.next,
                          ),

                          SizedBox(height: 24),

                          // Address section title
                          Text(
                            "Address Information",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(height: 32),

                          // Current address
                          _buildTextField(
                            controller: _currentAddressController,
                            label: AppStrings.currentAddress,
                            hint: "Enter current residential address",
                            icon: Icons.location_on_outlined,
                            maxLines: 3,
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return "Please enter a valid address";
                              }
                              return null;
                            },
                          ),

                          // Same address checkbox - styled
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CheckboxListTile(
                              title: Text("Same as Current Address"),
                              value: _isSameAddress,
                              activeColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                          ),

                          // Permanent address
                          SizedBox(height: 8),
                          _buildTextField(
                            controller: _permanentAddressController,
                            label: AppStrings.permanentAddress,
                            hint: "Enter permanent address",
                            icon: Icons.home_outlined,
                            maxLines: 3,
                            enabled: !_isSameAddress,
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return "Please enter a valid address";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 32),

                          // Submit button
                          Consumer(builder: (context, ref, child) {
                            final employeeState =
                                ref.read(employeeNotifierProvider);

                            ref.listen<EmployeeState>(employeeNotifierProvider,
                                (previous, next) {
                              next.maybeWhen(
                                failed: (message) {
                                  AppUtils.showSnackBar(context,
                                      content: message,
                                      isForErrorMessage: true);
                                },
                                createEmployeeSuccess: (user) {
                                  context.back();
                                  AppUtils.showSnackBar(context,
                                      content:
                                          AppStrings.employeeCreatedSuccess,
                                      isForErrorMessage: false);
                                },
                                orElse: () {},
                              );
                            });

                            return SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: employeeState.maybeMap(
                                loading: (_) => PrimaryButton(
                                    label: AppStrings.createEmployee,
                                    isLoading: true,
                                    onPressed: () {}),
                                orElse: () => ElevatedButton.icon(
                                  icon: Icon(Icons.add),
                                  label: Text(AppStrings.createEmployee),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      final uid = Uuid().v8();
                                      final employeeDetails = EmployeeEntity(
                                        uid: uid,
                                        contactAddress:
                                            _currentAddressController.text,
                                        permenentAddress:
                                            _permanentAddressController.text,
                                        fullname: _nameController.text,
                                        mobile: _mobileController.text,
                                        specialisation:
                                            _specialisedServiceController.text,
                                      );
                                      log("here $employeeDetails");
                                      ref
                                          .read(
                                              employeeNotifierProvider.notifier)
                                          .createEmployee(
                                              employee: employeeDetails);
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create consistent text fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int? maxLines = 1,
    bool enabled = true,
    TextInputType? textInputType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: context.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled
                ? context.colorScheme.surface
                : context.colorScheme.surfaceVariant.withOpacity(0.3),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines! > 1 ? 16 : 0,
            ),
          ),
          validator: validator,
          maxLines: maxLines,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          enabled: enabled,
        ),
      ],
    );
  }
}
