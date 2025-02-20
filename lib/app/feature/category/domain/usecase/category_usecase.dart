import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/domain/repositories/category_repository.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';

class CategoryUsecase extends UseCase<Either<Failure, EmployeeEnitity>, Unit> {
  final CategoryRepository categoryRepository;
  CategoryUsecase({
    required this.categoryRepository,
  });

  @override
  Future<Either<Failure, EmployeeEnitity>> call({required Unit params}) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> createCategory(
      {required CategoryEntity category}) {
    return categoryRepository.createCategory(category: category);
  }

  Future<Either<Failure, List<CategoryEntity>>> getCategories() {
    return categoryRepository.getCategories();
  }

  Future<Either<Failure, bool>> updateCategory(
      {required CategoryEntity category}) {
    return categoryRepository.updateCategories(category: category);
  }

  // Future<Either<Failure, bool>> deleteEmployees({required String employeeUid}) {
  //   return categoryRepository.deleteEmployee(uid: employeeUid);
  // }
}
