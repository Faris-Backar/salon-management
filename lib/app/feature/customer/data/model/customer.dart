import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';

class Customer extends CustomerEntity {
  Customer(
      {required super.uid,
      required super.name,
      required super.mobileNumber,
      required super.address});
}
