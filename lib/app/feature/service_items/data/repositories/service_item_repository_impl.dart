import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/firebase_utils.dart';
import 'package:salon_management/app/feature/service_items/data/model/service_item.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/domain/repositories/service_repository.dart';

class ServiceItemRepositoryImpl extends ServiceItemsRepository {
  final FirebaseFirestore firestore;

  ServiceItemRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, bool>> createServiceItems(
      {required ServiceItemEntity serviceItems}) async {
    try {
      final docRef = firestore
          .collection(FirebaseResources.serviceItem)
          .doc(serviceItems.uid);
      await docRef.set(serviceItems.toMap());
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> disableServiceItems(
      {required String serviceUid}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ServiceItemEntity>>> getServiceItems() async {
    try {
      final querySnapshot =
          await firestore.collection(FirebaseResources.serviceItem).get();

      final categories = querySnapshot.docs.map((doc) {
        return ServiceItem.fromJson(doc.data());
      }).toList();

      return Right(categories);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateServiceItems(
      {required ServiceItemEntity serviceItems}) async {
    try {
      final docRef = firestore
          .collection(FirebaseResources.serviceItem)
          .doc(serviceItems.uid);
      final updatedData = serviceItems.toMap();
      await docRef.update(updatedData);
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(message: FirebaseUtils.handleFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(message: "An unexpected error occurred: $e"));
    }
  }
}
