import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/repository/transaction_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/usecase/params/transaction_params.dart';

class TransactionUsecase extends UseCase<
    Either<Failure, List<TransactionEntity>>, TransactionParams> {
  final TransactionRepository transactionRepository;
  TransactionUsecase({required this.transactionRepository});
  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
      {required TransactionParams params}) {
    return transactionRepository.getTransactions(transParams: params);
  }
}
