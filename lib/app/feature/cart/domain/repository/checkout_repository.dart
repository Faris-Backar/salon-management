import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, Unit>> checkout({required TransactionEntity bill});
}
