import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/domain/repositories/service_repository.dart';

class ServiceItemUsecase
    extends UseCase<Either<Failure, ServiceItemEntity>, Unit> {
  final ServiceItemsRepository serviceItemRepository;
  ServiceItemUsecase({
    required this.serviceItemRepository,
  });
  @override
  Future<Either<Failure, ServiceItemEntity>> call({required Unit params}) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> createServiceItem(
      {required ServiceItemEntity serviceItems}) {
    return serviceItemRepository.createServiceItems(serviceItems: serviceItems);
  }

  Future<Either<Failure, List<ServiceItemEntity>>> getServiceItems() {
    return serviceItemRepository.getServiceItems();
  }

  Future<Either<Failure, bool>> updateServiceItems(
      {required ServiceItemEntity serviceItem}) {
    return serviceItemRepository.updateServiceItems(serviceItems: serviceItem);
  }

  Future<Either<Failure, bool>> deleteServiceItems(
      {required String customerUid}) {
    return serviceItemRepository.disableServiceItems(serviceUid: customerUid);
  }
}
