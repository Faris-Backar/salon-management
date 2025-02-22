import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/usecase/params/transaction_params.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
      {required TransactionParams transParams});
}
