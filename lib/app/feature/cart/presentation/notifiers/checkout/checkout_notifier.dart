import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/cart/data/repositories/check_out_repository_impl.dart';

import 'package:salon_management/app/feature/cart/domain/entities/bill_entities.dart';
import 'package:salon_management/app/feature/cart/domain/repository/checkout_repository.dart';
import 'package:salon_management/app/feature/cart/domain/usecase/check_out_usecase.dart';

import 'checkout_state.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CheckOutUsecase checkOutUsecase;
  CheckoutNotifier({required this.checkOutUsecase})
      : super(const CheckoutState.initial());

  Future<void> processCheckout(BillEntities bill) async {
    state = const CheckoutState.loading();
    try {
      await checkOutUsecase(params: bill);
      state = CheckoutState.success();
    } catch (e) {
      state = CheckoutState.failure(e.toString());
    }
  }
}

final checkOutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckOutRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider));
});

final checkOutUsercaseProvider = Provider<CheckOutUsecase>((ref) {
  final repository = ref.read(checkOutRepositoryProvider);
  return CheckOutUsecase(checkoutRepository: repository);
});

final checkoutNotifierProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final checkoutUsecase = ref.read(checkOutUsercaseProvider);
  return CheckoutNotifier(checkOutUsecase: checkoutUsecase);
});
