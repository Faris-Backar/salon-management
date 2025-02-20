import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
part 'category_state.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.categoryFetched(
      {required List<CategoryEntity> employeeList}) = _CategoryFetched;
  const factory CategoryState.createCategorysuccess({required bool isSuccess}) =
      _CreateCategorysuccess;
  const factory CategoryState.updateCategorysuccess({required bool isSuccess}) =
      _UpdateCategorysuccess;
  const factory CategoryState.deleteCategorysuccess({required bool isSuccess}) =
      _DeleteCategorysuccess;
  const factory CategoryState.failed({required String error}) = _Failed;
}
