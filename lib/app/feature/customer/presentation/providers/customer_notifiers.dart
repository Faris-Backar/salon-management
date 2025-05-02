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

  List<CustomerEntity> customers = [];
  CustomerEntity? selectedCustomer;

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

  fetchCustomer({bool isRefresh = false}) async {
    if (customers.isNotEmpty && !isRefresh) {
      state = CustomerState.customerFetched(employeeList: customers);
      return customers;
    }

    state = CustomerState.initial();
    state = CustomerState.loading();

    final result = await customerUsecase.getCustomers();

    return result.fold((l) {
      state = CustomerState.failed(error: l.message);
      return ServerFailure();
    }, (r) {
      customers = r; // Update the cache
      state = CustomerState.customerFetched(employeeList: r);
      return r;
    });
  }

  void searchCustomer(String query) async {
    state = const CustomerState.loading();

    try {
      final customerList = customers.where((customer) {
        final name = customer.name.toLowerCase();
        final phone = customer.mobileNumber;
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || phone.contains(searchQuery);
      }).toList();

      state = CustomerState.customerFetched(
          employeeList: query.isEmpty ? customers : customerList);
    } catch (e) {
      state = CustomerState.failed(error: e.toString());
    }
  }

  Future<List<CustomerEntity>> searchCustomerByPhone(String phoneNumber) async {
    // First ensure we have the latest customer data
    if (customers.isEmpty) {
      final result = await customerUsecase.getCustomers();
      result.fold(
        (l) => [],
        (r) => customers = r,
      );
    }

    // Search for exact phone number match
    return customers
        .where((customer) => customer.mobileNumber == phoneNumber)
        .toList();
  }
}
