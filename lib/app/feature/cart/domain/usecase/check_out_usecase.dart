import 'package:dartz/dartz.dart';

import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/cart/domain/entities/bill_entities.dart';
import 'package:salon_management/app/feature/cart/domain/repository/checkout_repository.dart';

class CheckOutUsecase extends UseCase<Either<Failure, Unit>, BillEntities> {
  final CheckoutRepository checkoutRepository;
  CheckOutUsecase({
    required this.checkoutRepository,
  });
  @override
  Future<Either<Failure, Unit>> call({required BillEntities params}) {
    return checkoutRepository.checkout(bill: params);
  }
}
