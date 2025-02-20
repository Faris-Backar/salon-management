import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category implements CategoryEntity {
  factory Category({
    required String uid,
    required String name,
    required bool isActive,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
