import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

class CartState {
  final List<ServiceItemEntity> selectedServices;
  final CustomerEntity? customer;
  final EmployeeEntity? employee;
  final double totalAmount;
  final double discountAmount;
  final String paymentMode;

  CartState(
      {this.selectedServices = const [],
      this.customer,
      this.employee,
      this.totalAmount = 0.0,
      this.discountAmount = 0.0,
      this.paymentMode = "Cash"});

  CartState copyWith(
      {List<ServiceItemEntity>? selectedServices,
      CustomerEntity? customer,
      EmployeeEntity? employee,
      double? totalAmount,
      double? discountAmount,
      String? paymentMode}) {
    return CartState(
        selectedServices: selectedServices ?? this.selectedServices,
        customer: customer ?? this.customer,
        employee: employee ?? this.employee,
        totalAmount: totalAmount ?? this.totalAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        paymentMode: paymentMode ?? this.paymentMode);
  }
}
