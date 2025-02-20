import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/utils/app_utils.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_state.dart';
import 'package:salon_management/app/feature/widgets/custom_text_field.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _nameController = TextEditingController();
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: AppStrings.categoryName,
                controller: _nameController,
                hint: AppStrings.categoryName,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Please enter a valid name";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final categoryItemState = ref.read(categoryNotifierProvider);
          ref.listen<CategoryState>(categoryNotifierProvider, (previous, next) {
            next.maybeWhen(
              failed: (message) {
                AppUtils.showSnackBar(context,
                    content: message, isForErrorMessage: true);
              },
              createCategorysuccess: (user) {
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
            child: categoryItemState.maybeMap(
              loading: (_) => PrimaryButton(
                  label: AppStrings.createEmployee,
                  isLoading: true,
                  onPressed: () {}),
              orElse: () => PrimaryButton(
                label: AppStrings.addService,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    final uid = Uuid().v8();
                    final category = CategoryEntity(
                      uid: uid,
                      name: _nameController.text,
                      isActive: true,
                    );
                    ref
                        .read(categoryNotifierProvider.notifier)
                        .createCategoryItems(category: category);
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
