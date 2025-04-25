import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/error/failure.dart';
import 'package:salon_management/app/core/usecase/usecase.dart';
import 'package:salon_management/app/feature/settings/domain/repository/expense_repository.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class AddExpenseUsecase implements UseCase<void, TransactionEntity> {
  final ExpenseRepository expenseRepository;

  AddExpenseUsecase({required this.expenseRepository});

  @override
  Future<Either<Failure, void>> call(
      {required TransactionEntity params}) async {
    return await expenseRepository.addExpense(params);
  }
}
