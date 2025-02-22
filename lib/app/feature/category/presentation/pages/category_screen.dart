import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/category/data/data/category.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryNotifierProvider);
    return Scaffold(
      appBar: Responsive.isDesktop()
          ? null
          : AppBar(
              title: Text(AppStrings.categories),
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
      body: state.when(
        initial: () =>
            const Center(child: Text("Welcome! Fetching categories...")),
        loading: () => const Center(child: CircularProgressIndicator()),
        categoryFetched: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text("No categories found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Slidable(
                key: ValueKey(category.uid),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        final categoryUpdated = Category(
                            uid: category.uid,
                            name: category.name,
                            isActive: false);
                        ref
                            .read(categoryNotifierProvider.notifier)
                            .updateCategoryItems(category: categoryUpdated);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.block,
                      label: 'Deactivate',
                    ),
                  ],
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(category.isActive ? "Active" : "Inactive"),
                    leading: Icon(Icons.category,
                        color: context.colorScheme.primary),
                  ),
                ),
              );
            },
          );
        },
        failed: (error) => Center(child: Text("Error: $error")),
        createCategorysuccess: (_) => const SizedBox(),
        updateCategorysuccess: (_) => const SizedBox(),
        deleteCategorysuccess: (_) => const SizedBox(),
      ),
    );
  }
}
