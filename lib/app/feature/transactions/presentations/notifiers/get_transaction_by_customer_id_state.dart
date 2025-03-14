import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

class GetTransactionByCustomerIdState {
  final List<TransactionEntity>? transactions;
  final bool isLoading;
  final String? errorMessage;

  GetTransactionByCustomerIdState({
    this.transactions,
    this.isLoading = false,
    this.errorMessage,
  });

  GetTransactionByCustomerIdState copyWith({
    List<TransactionEntity>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GetTransactionByCustomerIdState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
