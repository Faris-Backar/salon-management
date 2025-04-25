import 'package:equatable/equatable.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseSuccess extends ExpenseState {
  const ExpenseSuccess();
}

class ExpenseFailure extends ExpenseState {
  final String message;

  const ExpenseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
