import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/domain/usecase/customer_usecase.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_state.dart';

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerUsecase customerUsecase;
  CustomerNotifier({
    required this.customerUsecase,
  }) : super(CustomerState.initial());

  createcustomer({required CustomerEntity customer}) async {
    state = CustomerState.initial();
    state = CustomerState.loading();
    final result =
        await customerUsecase.createCustomer(customerEntity: customer);
    result.fold((l) {
      state = CustomerState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CustomerState.createCustomeruccess(isSuccess: r);
      return r;
    });
  }

  updatecustomer({required CustomerEntity customer}) async {
    state = CustomerState.initial();
    state = CustomerState.loading();
    final result = await customerUsecase.updateCustomers(customer: customer);
    result.fold((l) {
      state = CustomerState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CustomerState.updateCustomeruccess(isSuccess: r);
      return r;
    });
  }

  deletecustomer({required String customerUid}) async {
    state = CustomerState.initial();
    state = CustomerState.loading();
    final result =
        await customerUsecase.deleteCustomers(customerUid: customerUid);
    result.fold((l) {
      state = CustomerState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CustomerState.deleteCustomeruccess(isSuccess: r);
      return r;
    });
  }

  fetchcustomer({required CustomerEntity customer}) async {
    state = CustomerState.initial();
    state = CustomerState.loading();
    final result = await customerUsecase.getCustomers();
    result.fold((l) {
      state = CustomerState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      state = CustomerState.customerFetched(employeeList: r);
      return r;
    });
  }
}
