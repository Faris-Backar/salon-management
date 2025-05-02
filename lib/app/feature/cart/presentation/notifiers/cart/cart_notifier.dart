import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'cart_state.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addService(ServiceItemEntity service) {
    state = state.copyWith(
      selectedServices: [...state.selectedServices, service],
    );
  }

  void removeService(int index) {
    final updatedServices = [...state.selectedServices]..removeAt(index);
    state = state.copyWith(selectedServices: updatedServices);
  }

  void updateService(int index, ServiceItemEntity updatedService) {
    final updatedServices = [...state.selectedServices];
    updatedServices[index] = updatedService;
    state = state.copyWith(selectedServices: updatedServices);
  }

  void setCustomerDetails(CustomerEntity customer) {
    state = state.copyWith(customer: customer);
  }

  void setEmployee(EmployeeEntity employee) {
    state = state.copyWith(employee: employee);
  }

  double get totalAmount {
    return state.selectedServices.fold(0.0, (sum, service) {
      return sum + (double.tryParse(service.price) ?? 0.0);
    });
  }

  Future<void> clearCart() async {
    state = CartState();
    return;
  }
}

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);
