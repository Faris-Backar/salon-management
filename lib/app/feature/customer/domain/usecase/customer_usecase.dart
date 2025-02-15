import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/domain/repositories/customer_repository.dart';

class CustomerUsecase extends UseCase<Either<Failure, CustomerEntity>, Unit> {
  final CustomerRepository customerRepository;
  CustomerUsecase({
    required this.customerRepository,
  });
  @override
  Future<Either<Failure, CustomerEntity>> call({required Unit params}) {
    throw UnimplementedError();
  }

  Future<Either<Failure, bool>> createCustomer(
      {required CustomerEntity customerEntity}) {
    return customerRepository.createCustomer(customer: customerEntity);
  }

  Future<Either<Failure, List<CustomerEntity>>> getCustomers() {
    return customerRepository.getCustomers();
  }

  Future<Either<Failure, bool>> updateCustomers(
      {required CustomerEntity customer}) {
    return customerRepository.updateCustomers(customer: customer);
  }

  Future<Either<Failure, bool>> deleteCustomers({required String customerUid}) {
    return customerRepository.deleteCustomers(customerUid: customerUid);
  }
}
