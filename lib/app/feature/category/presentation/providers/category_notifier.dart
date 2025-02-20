import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/domain/usecase/category_usecase.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_state.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryUsecase categoryUsecase;
  CategoryNotifier({
    required this.categoryUsecase,
  }) : super(CategoryState.initial());

  createCategoryItems({required CategoryEntity category}) async {
    state = CategoryState.initial();
    state = CategoryState.loading();
    final result = await categoryUsecase.createCategory(category: category);
    result.fold((l) {
      state = CategoryState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CategoryState.createCategorysuccess(isSuccess: r);
      return r;
    });
  }

  updateCategoryItems({required CategoryEntity category}) async {
    state = CategoryState.initial();
    state = CategoryState.loading();
    final result = await categoryUsecase.updateCategory(category: category);
    result.fold((l) {
      state = CategoryState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CategoryState.updateCategorysuccess(isSuccess: r);
      return r;
    });
  }

  // deleteServiceItem({required String customerUid}) async {
  //   state = CategoryState.initial();
  //   state = CategoryState.loading();
  //   final result =
  //       await categoryUsecase.(customerUid: customerUid);
  //   result.fold((l) {
  //     state = CategoryState.failed(error: l.message);
  //     return ServerFailure();
  //   }, (r) {
  //     state = CategoryState.deleteServiceItemsuccess(isSuccess: r);
  //     return r;
  //   });
  // }

  fetchCategoriesItems() async {
    state = CategoryState.initial();
    state = CategoryState.loading();
    final result = await categoryUsecase.getCategories();
    result.fold((l) {
      state = CategoryState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CategoryState.categoryFetched(employeeList: r);
      return r;
    });
  }
}
