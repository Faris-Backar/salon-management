import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/category/data/data/category.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/service_items/domain/usecase/service_item_usecase.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_state.dart';

class ServiceItemNotifier extends StateNotifier<ServiceItemState> {
  final ServiceItemUsecase serviceItemUsecase;
  ServiceItemNotifier({
    required this.serviceItemUsecase,
  }) : super(ServiceItemState.initial());

  List<ServiceItemEntity> serviceItems = [];

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

  fetchServiceItems({bool isRefresh = false}) async {
    if (serviceItems.isNotEmpty && !isRefresh) {
      state = ServiceItemState.serviceItemsFetched(serviceItems: serviceItems);
      return serviceItems;
    }
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();

    final result = await serviceItemUsecase.getServiceItems();

    return result.fold((l) {
      state = ServiceItemState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      r.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      serviceItems = r; // Update the cache
      state = ServiceItemState.serviceItemsFetched(serviceItems: r);
      return r;
    });
  }

  List<ServiceItemEntity> fetchServiceItemsBasedonCategory(
      {required String categoryUid, bool isForAll = false}) {
    state = ServiceItemState.initial();
    state = ServiceItemState.loading();
    final filteredResult = serviceItems
        .where((service) => service.categoryUid == categoryUid)
        .toList();
    state = ServiceItemState.serviceItemsFetched(
        serviceItems: isForAll ? serviceItems : filteredResult);
    return filteredResult;
  }

  void updateCategoryItems({required Category category}) {}
}
