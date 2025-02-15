import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
part 'customer_state.freezed.dart';

@freezed
class CustomerState with _$CustomerState {
  const factory CustomerState.initial() = _Initial;
  const factory CustomerState.loading() = _Loading;
  const factory CustomerState.customerFetched(
      {required List<CustomerEntity> employeeList}) = _CustomerFetched;
  const factory CustomerState.createCustomeruccess({required bool isSuccess}) =
      _CreateCustomeruccess;
  const factory CustomerState.updateCustomeruccess({required bool isSuccess}) =
      _UpdateCustomeruccess;
  const factory CustomerState.deleteCustomeruccess({required bool isSuccess}) =
      _DeleteCustomeruccess;
  const factory CustomerState.failed({required String error}) = _Failed;
}
