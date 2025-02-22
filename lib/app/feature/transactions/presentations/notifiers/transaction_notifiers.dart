import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/transactions/data/repositories/transaction_repositories_impl.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:salon_management/app/feature/transactions/domain/usecase/params/transaction_params.dart';

final transactionRepositoryProvider = Provider((ref) =>
    TransactionRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider)));

final fromDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().subtract(const Duration(days: 1));
});

final toDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final transactionsProvider =
    FutureProvider<List<TransactionEntity>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final from = ref.watch(fromDateProvider);
  final to = ref.watch(toDateProvider);
  final result = await repository.getTransactions(
      transParams: TransactionParams(fromDate: from, toDate: to));
  return result.fold(
    (l) => [],
    (r) => r,
  );
});

final totalAmountProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider).asData?.value ?? [];
  return transactions.fold(0.0, (sum, item) => sum + (item.totalAmount));
});
