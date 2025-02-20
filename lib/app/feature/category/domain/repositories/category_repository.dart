import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, bool>> createCategory(
      {required CategoryEntity category});
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, bool>> updateCategories(
      {required CategoryEntity category});
}
