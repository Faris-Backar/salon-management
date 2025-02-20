import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/category/data/data/category.dart';
import 'package:salon_management/app/feature/category/domain/entities/category_entity.dart';
import 'package:salon_management/app/feature/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final FirebaseFirestore firestore;

  CategoryRepositoryImpl({required this.firestore});
  @override
  Future<Either<Failure, bool>> createCategory(
      {required CategoryEntity category}) async {
    try {
      final docRef =
          firestore.collection(FirebaseResources.category).doc(category.uid);
      await docRef.set(category.toMap());
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final querySnapshot =
          await firestore.collection(FirebaseResources.category).get();

      final categories = querySnapshot.docs.map((doc) {
        return Category.fromJson(doc.data());
      }).toList();

      return Right(categories);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCategories(
      {required CategoryEntity category}) {
    throw UnimplementedError();
  }
}
