import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/employee/data/repositories/employee_repository_impl.dart';
import 'package:salon_management/app/feature/employee/domain/repositories/employee_repository.dart';
import 'package:salon_management/app/feature/employee/domain/usecases/employee_usecase.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_notifiers.dart';
import 'package:salon_management/app/feature/employee/presentation/providers/employee_state.dart';

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) =>
    EmployeeRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider)));

final employeeUseCaseProvider = Provider(
  (ref) =>
      EmployeeUsecase(employeeRepository: ref.read(employeeRepositoryProvider)),
);

final employeeNotifierProvider =
    StateNotifierProvider<EmployeeNotifier, EmployeeState>(
  (ref) => EmployeeNotifier(
    employeeUsecase: ref.read(employeeUseCaseProvider),
  ),
);
