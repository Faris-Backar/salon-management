import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> addExpense(
      TransactionEntity expenseTransaction);
}
