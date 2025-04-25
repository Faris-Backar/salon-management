import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/employee/domain/entities/employee_enitity.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_provider.dart';
import 'package:salon_management/app/feature/settings/data/repositories/expense_repository_impl.dart';
import 'package:salon_management/app/feature/settings/domain/repository/expense_repository.dart';
import 'package:salon_management/app/feature/settings/domain/usecase/add_expense_usecase.dart';
import 'package:salon_management/app/feature/settings/presentation/notifiers/expense/expense_state.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:uuid/uuid.dart';

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  final AddExpenseUsecase _addExpenseUsecase;
  final Ref _ref;

  ExpenseNotifier({
    required AddExpenseUsecase addExpenseUsecase,
    required Ref ref,
  })  : _addExpenseUsecase = addExpenseUsecase,
        _ref = ref,
        super(const ExpenseInitial());

  Future<void> addExpense({
    required String amount,
    required String remarks,
    required String employeeId,
  }) async {
    state = const ExpenseLoading();

    try {
      // Get employee from the provider
      final employeeState = _ref.read(employeeNotifierProvider);

      EmployeeEntity? employee;
      bool employeeFound = false;

      employeeState.maybeWhen(
        employeesFetched: (employees) {
          for (var emp in employees) {
            if (emp.uid == employeeId) {
              employee = emp;
              employeeFound = true;
              break;
            }
          }
        },
        orElse: () {},
      );

      if (!employeeFound) {
        throw Exception('Employee not found');
      }

      final transaction = TransactionEntity(
        uid: const Uuid().v4(),
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        type: TransactionType.expense,
        paymentMethod: 'Cash',
        amount: double.parse(amount),
        expenseCategory: 'General',
        expenseDescription: remarks,
        employee: employee,
      );

      final result = await _addExpenseUsecase(params: transaction);

      result.fold(
        (failure) => state = ExpenseFailure(failure.message),
        (_) => state = const ExpenseSuccess(),
      );
    } catch (e) {
      state = ExpenseFailure(e.toString());
    }
  }
}

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return ExpenseRepositoryImpl(firestore: firestore);
});

final addExpenseUsecaseProvider = Provider<AddExpenseUsecase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return AddExpenseUsecase(expenseRepository: repository);
});

final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  final addExpenseUsecase = ref.watch(addExpenseUsecaseProvider);
  return ExpenseNotifier(
    addExpenseUsecase: addExpenseUsecase,
    ref: ref,
  );
});
