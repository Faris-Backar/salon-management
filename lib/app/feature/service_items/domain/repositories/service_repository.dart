import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

abstract class ServiceItemsRepository {
  Future<Either<Failure, List<ServiceItemEntity>>> getServiceItems();
  Future<Either<Failure, bool>> createServiceItems(
      {required ServiceItemEntity serviceItems});
  Future<Either<Failure, bool>> updateServiceItems(
      {required ServiceItemEntity serviceItems});
  Future<Either<Failure, bool>> disableServiceItems(
      {required String serviceUid});
}
