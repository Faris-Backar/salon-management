import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/customer/data/repositories/customer_repository_impl.dart';
import 'package:salon_management/app/feature/customer/domain/repositories/customer_repository.dart';
import 'package:salon_management/app/feature/customer/domain/usecase/customer_usecase.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_notifiers.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_state.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) =>
    CustomerRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider)));

final customerUseCaseProvider = Provider(
  (ref) =>
      CustomerUsecase(customerRepository: ref.read(customerRepositoryProvider)),
);

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>(
  (ref) => CustomerNotifier(
    customerUsecase: ref.read(customerUseCaseProvider),
  ),
);
