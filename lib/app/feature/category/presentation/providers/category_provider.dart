import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/category/data/repositories/category_repository_impl.dart';
import 'package:salon_management/app/feature/category/domain/repositories/category_repository.dart';
import 'package:salon_management/app/feature/category/domain/usecase/category_usecase.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_notifier.dart';
import 'package:salon_management/app/feature/category/presentation/providers/category_state.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) =>
    CategoryRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider)));

final categoryUseCaseProvider = Provider(
  (ref) =>
      CategoryUsecase(categoryRepository: ref.read(categoryRepositoryProvider)),
);

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(
    categoryUsecase: ref.read(categoryUseCaseProvider),
  ),
);
