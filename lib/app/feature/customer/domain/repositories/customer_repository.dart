import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<CustomerEntity>>> getCustomers();
  Future<Either<Failure, bool>> createCustomer(
      {required CustomerEntity customer});
  Future<Either<Failure, bool>> updateCustomers(
      {required CustomerEntity customer});
  Future<Either<Failure, bool>> deleteCustomers({required String customerUid});
}
