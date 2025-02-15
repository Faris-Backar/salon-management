import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/domain/usecase/service_item_usecase.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_state.dart';

class ServiceItemNotifier extends StateNotifier<ServiceItemState> {
  final ServiceItemUsecase serviceItemUsecase;
  ServiceItemNotifier({
    required this.serviceItemUsecase,
  }) : super(ServiceItemState.initial());

  createServiceItems({required ServiceItemEntity serviceItems}) async {
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();
    final result =
        await serviceItemUsecase.createServiceItem(serviceItems: serviceItems);
    result.fold((l) {
      state = ServiceItemState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = ServiceItemState.createServiceItemsuccess(isSuccess: r);
      return r;
    });
  }

  updateServiceItems({required ServiceItemEntity serviceItems}) async {
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();
    final result =
        await serviceItemUsecase.updateServiceItems(serviceItem: serviceItems);
    result.fold((l) {
      state = ServiceItemState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = ServiceItemState.updateServiceItemsuccess(isSuccess: r);
      return r;
    });
  }

  deleteServiceItem({required String customerUid}) async {
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();
    final result =
        await serviceItemUsecase.deleteServiceItems(customerUid: customerUid);
    result.fold((l) {
      state = ServiceItemState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = ServiceItemState.deleteServiceItemsuccess(isSuccess: r);
      return r;
    });
  }

  fetchServiceItems({required ServiceItemEntity serviceItems}) async {
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();
    final result = await serviceItemUsecase.getServiceItems();
    result.fold((l) {
      state = ServiceItemState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = ServiceItemState.serviceItemsFetched(serviceItems: r);
      return r;
    });
  }
}
