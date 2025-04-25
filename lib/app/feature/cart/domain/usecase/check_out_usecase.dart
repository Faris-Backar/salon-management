import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/cart/domain/repository/checkout_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class CheckOutUsecase
    extends UseCase<Either<Failure, Unit>, TransactionEntity> {
  final CheckoutRepository checkoutRepository;
  CheckOutUsecase({
    required this.checkoutRepository,
  });
  @override
  Future<Either<Failure, Unit>> call({required TransactionEntity params}) {
    return checkoutRepository.checkout(bill: params);
  }
}
