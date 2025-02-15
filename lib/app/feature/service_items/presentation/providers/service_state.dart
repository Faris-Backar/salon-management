import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
part 'service_state.freezed.dart';

@freezed
class ServiceItemState with _$ServiceItemState {
  const factory ServiceItemState.initial() = _Initial;
  const factory ServiceItemState.loading() = _Loading;
  const factory ServiceItemState.serviceItemsFetched(
      {required List<ServiceItemEntity> serviceItems}) = _CustomerFetched;
  const factory ServiceItemState.createServiceItemsuccess(
      {required bool isSuccess}) = _CreateServiceItemsuccess;
  const factory ServiceItemState.updateServiceItemsuccess(
      {required bool isSuccess}) = _UpdateServiceItemsuccess;
  const factory ServiceItemState.deleteServiceItemsuccess(
      {required bool isSuccess}) = _DeleteServiceItemsuccess;
  const factory ServiceItemState.failed({required String error}) = _Failed;
}
