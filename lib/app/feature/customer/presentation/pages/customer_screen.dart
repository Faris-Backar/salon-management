import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/routes/app_router.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';

@RoutePage()
class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(customerNotifierProvider.notifier).fetchcustomer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerNotifierProvider);
    log("$customerState");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.customers),
        actions: [
          customerState.maybeWhen(
            customerFetched: (employeeList) => IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomerSearchDelegate(customers: employeeList),
                );
              },
            ),
            orElse: () => SizedBox.shrink(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.pushNamed(AppRouter.createCustomer),
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: customerState.maybeMap(
          customerFetched: (customer) {
            return ListView.separated(
              itemCount: customer.employeeList.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final customerDetails = customer.employeeList;
                return ListTile(
                  onTap: () {
                    ref
                        .read(customerNotifierProvider.notifier)
                        .selectedCustomer = customerDetails[index];
                    context.router.pushNamed(AppRouter.customerDetailsScreen);
                  },
                  tileColor: context.colorScheme.tertiaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(customerDetails[index].name),
                  subtitle: Text(customerDetails[index].mobileNumber),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                );
              },
            );
          },
          loading: (value) => Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          orElse: () => Text("No Data is Available"),
        ),
      ),
    );
  }
}

class CustomerSearchDelegate extends SearchDelegate<CustomerEntity?> {
  final List<CustomerEntity> customers;

  CustomerSearchDelegate({required this.customers});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = customers.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.mobileNumber.contains(query);
    }).toList();

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.mobileNumber),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () {
            close(context, customer);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = customers.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.mobileNumber.contains(query);
    }).toList();

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final customer = suggestions[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.mobileNumber),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () {
            close(context, customer);
          },
        );
      },
    );
  }
}
