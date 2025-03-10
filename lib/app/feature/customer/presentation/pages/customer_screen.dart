import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';

@RoutePage()
class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.customers),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomerSearchDelegate(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) => ListTile(
            tileColor: context.colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text("Customer $index"),
            subtitle: Text("+91 98765 4321$index"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:salon_management/app/features/customers/domain/entities/customer_entity.dart';

class CustomerSearchDelegate extends SearchDelegate {
  final List<CustomerEntity> customers;

  CustomerSearchDelegate(this.customers);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search field
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildCustomerList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildCustomerList();
  }

  Widget _buildCustomerList() {
    final filteredCustomers = customers.where((customer) {
      final name = customer..toLowerCase();
      final phone = customer.phone;
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || phone.contains(searchQuery);
    }).toList();

    if (filteredCustomers.isEmpty) {
      return Center(child: Text("No customers found"));
    }

    return ListView.builder(
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = filteredCustomers[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.phone),
          onTap: () {
            close(context, customer.name);
          },
        );
      },
    );
  }
}
