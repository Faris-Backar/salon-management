import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';

class CategoriesWidget extends ConsumerWidget {
  final ValueNotifier<String?> selectedCategoryUid;
  const CategoriesWidget({super.key, required this.selectedCategoryUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.read(categoryNotifierProvider);
    return categoriesState.maybeWhen(
      initial: () => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      categoryFetched: (categoryList) {
        return ValueListenableBuilder<String?>(
          valueListenable: selectedCategoryUid,
          builder: (context, selectedUid, child) {
            final allCategory = categoryList.firstWhere(
              (category) => category.name.toLowerCase() == "all",
              orElse: () => categoryList.first,
            );
            selectedCategoryUid.value ??= allCategory.uid;

            return Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryList[index];
                  final isSelected = selectedUid == category.uid;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        selectedCategoryUid.value = category.uid;

                        ref
                            .read(serviceItemNotifierProvider.notifier)
                            .fetchServiceItemsBasedonCategory(
                              categoryUid: category.uid,
                              isForAll: category.name.toLowerCase() == "all",
                            );
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2)
                              : context.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(category.name),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      orElse: () => SizedBox.shrink(),
    );
  }
}
