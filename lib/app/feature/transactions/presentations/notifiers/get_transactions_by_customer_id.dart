import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/transactions/data/repositories/transaction_repositories_impl.dart';
import 'package:salon_management/app/feature/transactions/domain/usecase/fetch_transactions_by_customer_id_usecase.dart';
import 'package:salon_management/app/feature/transactions/presentations/notifiers/get_transaction_by_customer_id_state.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, GetTransactionByCustomerIdState>(
        (ref) {
  final fetchTransactionsUseCase = FetchTransactionsUseCase(
    repository: TransactionRepositoryImpl(
        firestore: ref.read(firebaseFirestoreProvider)),
  );
  return TransactionNotifier(
      fetchTransactionsUseCase: fetchTransactionsUseCase);
});

class TransactionNotifier
    extends StateNotifier<GetTransactionByCustomerIdState> {
  final FetchTransactionsUseCase fetchTransactionsUseCase;

  TransactionNotifier({required this.fetchTransactionsUseCase})
      : super(GetTransactionByCustomerIdState(isLoading: true));

  Future<void> fetchTransactionsByCustomerId(String customerId) async {
    try {
      state = state.copyWith(isLoading: true);
      final transactions = await fetchTransactionsUseCase.execute(customerId);
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to fetch transactions', isLoading: false);
    }
  }
}
