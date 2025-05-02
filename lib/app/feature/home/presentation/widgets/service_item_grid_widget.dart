import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_provider.dart';

class ServiceItemGridWidget extends ConsumerWidget {
  const ServiceItemGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceItemsState = ref.watch(serviceItemNotifierProvider);

    return serviceItemsState.maybeWhen(
      serviceItemsFetched: (serviceItems) => GridView.builder(
        itemCount: serviceItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              ref
                  .read(cartNotifierProvider.notifier)
                  .addService(serviceItems[index]);
            },
            child: Card(
              elevation: 5.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      serviceItems[index].name,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${AppStrings.indianRupee}${serviceItems[index].price}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
