import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/repository/transaction_repository.dart';

class FetchTransactionsUseCase {
  final TransactionRepository repository;

  FetchTransactionsUseCase({required this.repository});

  Future<List<TransactionEntity>> execute(String customerId) async {
    return await repository.getTransactionsByCustomerId(customerId: customerId);
  }
}
