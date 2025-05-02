import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_notifier.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/checkout/checkout_state.dart';
import 'package:salon_management/app/feature/cart/presentation/widgets/bill_section.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';
import 'package:uuid/uuid.dart';

class BillingWidget extends ConsumerWidget {
  const BillingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCartState = ref.watch(cartNotifierProvider);
    ref.listen<CheckoutState>(checkoutNotifierProvider, (previous, next) {
      next.maybeWhen(
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
        failure: (error) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Checkout Failed"),
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        success: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Checkout Successful"),
                content:
                    const Text("The bill has been processed successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      final cartNotifier =
                          ref.read(cartNotifierProvider.notifier);

                      cartNotifier.clearCart();
                      context.router.popForced();
                      context.router.popForced();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        orElse: () {},
      );
    });

    return BillSection(
      selectedServices: currentCartState.selectedServices,
      totalAmount: ref.read(cartNotifierProvider.notifier).totalAmount,
      onCheckout: (amount, paymentMethod) {
        final uid = const Uuid().v8();
        final bill = TransactionEntity(
          type: TransactionType.income,
          uid: uid,
          selectedServices: currentCartState.selectedServices,
          customer: currentCartState.customer,
          employee: currentCartState.employee,
          amount: amount,
          discountAmount: 0.0,
          paymentMethod: paymentMethod,
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
        );
        ref.read(checkoutNotifierProvider.notifier).processCheckout(bill);
      },
      onClearBill: () {
        ref.read(cartNotifierProvider.notifier).clearCart();
      },
    );
  }
}
