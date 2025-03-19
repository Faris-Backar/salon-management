// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class BillSection extends StatefulWidget {
  final String shopName;
  final String shopLogo;
  final String contactNumber;
  final String email;
  final String address;
  final String slogan;
  final List<ServiceItemEntity> selectedServices;
  final String customerName;
  final String customerPhoneNumber;
  final String employeeName;
  final double totalAmount;
  final VoidCallback onClearBill;
  final Function(double, String) onCheckout;

  const BillSection({
    required this.shopName,
    required this.shopLogo,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.slogan,
    required this.selectedServices,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.employeeName,
    required this.totalAmount,
    required this.onClearBill,
    required this.onCheckout,
    super.key,
  });

  @override
  _BillSectionState createState() => _BillSectionState();
}

class _BillSectionState extends State<BillSection> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = "CASH";

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toStringAsFixed(2);
  }

  void _showCheckoutDialog(BuildContext context, WidgetRef ref) {
    bool sendToWhatsApp = false;
    String? selectedCustomerName;
    String? selectedCustomerPhone;

    TextEditingController amountController =
        TextEditingController(text: widget.totalAmount.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Checkout"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Amount:"),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: "₹ ",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Select Customer:"),
                    GestureDetector(
                      onTap: () => _showCustomerSelectionSheet(context, ref,
                          (name, number) {
                        setDialogState(() {
                          selectedCustomerName = name;
                          selectedCustomerPhone = number;
                        });
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: context.colorScheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCustomerName ??
                                  "Select Customer (or Guest)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: selectedCustomerName != null
                                    ? context.colorScheme.onSurface
                                    : context.colorScheme.outline,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Payment Method:"),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() {
                              _selectedPaymentMethod = "CASH";
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedPaymentMethod == "CASH"
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surfaceContainer,
                                  width: 2,
                                ),
                                color: _selectedPaymentMethod == "CASH"
                                    ? context.colorScheme.primary
                                        .withOpacity(0.2)
                                    : context.colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text("CASH",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(() {
                              _selectedPaymentMethod = "ONLINE";
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedPaymentMethod == "ONLINE"
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surfaceContainer,
                                  width: 2,
                                ),
                                color: _selectedPaymentMethod == "ONLINE"
                                    ? context.colorScheme.primary
                                        .withOpacity(0.2)
                                    : context.colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text("ONLINE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: sendToWhatsApp,
                          onChanged: (value) {
                            setDialogState(() {
                              sendToWhatsApp = value!;
                            });
                          },
                        ),
                        const Text("Send Bill to WhatsApp"),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    double enteredAmount =
                        double.tryParse(amountController.text) ??
                            widget.totalAmount;
                    String finalCustomerName = selectedCustomerName ?? "Guest";
                    String finalCustomerPhone = selectedCustomerPhone ?? "N/A";

                    widget.onCheckout(enteredAmount, _selectedPaymentMethod);

                    if (sendToWhatsApp) {
                      _sendBillToWhatsApp(
                          enteredAmount, finalCustomerName, finalCustomerPhone);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Checkout"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear Bill"),
          content: const Text("Are you sure you want to clear the bill?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onClearBill();
                context.router.popForced();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                "Clear",
                style: TextStyle(color: context.colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerSelectionSheet(
      BuildContext context, WidgetRef ref, Function(String, String) onSelect) {
    ref.read(customerNotifierProvider.notifier).fetchcustomer();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceBright,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final customerState = ref.watch(customerNotifierProvider);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Customer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  customerState.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    failed: (error) => Center(child: Text("Error: $error")),
                    customerFetched: (employeeList) => Column(
                      children: [
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search Customer...",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (query) {
                              ref
                                  .read(customerNotifierProvider.notifier)
                                  .searchCustomer(query);
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Customer List
                        SizedBox(
                          height: 300, // Limit height for scrolling
                          child: ListView.builder(
                            itemCount: employeeList.length,
                            itemBuilder: (context, index) {
                              final customer = employeeList[index];
                              return ListTile(
                                title: Text(customer.name),
                                subtitle: Text(customer.mobileNumber),
                                onTap: () {
                                  onSelect(
                                      customer.name, customer.mobileNumber);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    orElse: () =>
                        const Center(child: Text("Something went wrong")),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _sendBillToWhatsApp(
      double amount, String customerName, String customerPhone) async {
    String message = """
  *Salon Bill*
  🏢 ${widget.shopName}
  📍 ${widget.address}
  📞 ${widget.contactNumber}
  
  👤 Customer: $customerName - $customerPhone
  👨‍💼 Employee: ${widget.employeeName}

  🛒 Services:
  ${widget.selectedServices.asMap().entries.map((entry) => "${entry.key + 1}. ${entry.value.name} - ₹${entry.value.price}").join("\n")}

  💰 Total: ₹${amount.toStringAsFixed(2)}
  💳 Payment Method: $_selectedPaymentMethod
  
  🏷 Thank you for visiting!
  """;

    String url =
        "https://wa.me/${customerPhone != 'N/A' ? customerPhone : widget.contactNumber}?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: context.colorScheme.surfaceBright,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset(widget.shopLogo, height: 150)),
            const SizedBox(height: 8),
            Text(widget.shopName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.address),
            Text("Contact: ${widget.contactNumber}"),
            const Divider(thickness: 2),
            Text(
                "Customer: ${widget.customerName} - ${widget.customerPhoneNumber}"),
            Text("Employee: ${widget.employeeName}"),
            const Divider(thickness: 2),
            const Text("Services:"),
            Expanded(
              child: Consumer(builder: (context, WidgetRef ref, child) {
                return ListView.builder(
                  itemCount: widget.selectedServices.length,
                  itemBuilder: (context, index) {
                    final service = widget.selectedServices[index];
                    return Slidable(
                      key: ValueKey(service.uid),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => ref
                                .read(cartNotifierProvider.notifier)
                                .removeService(index),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Remove',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text("${index + 1}. ${service.name}"),
                        trailing: Text("₹${service.price}"),
                      ),
                    );
                  },
                );
              }),
            ),
            const Divider(thickness: 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text("Total: ₹${widget.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(widget.slogan,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButton(
                  onPressed: _showClearConfirmationDialog,
                  isOutlineButton: true,
                  child: const Text("Clear"),
                ),
                Consumer(builder: (context, ref, child) {
                  return PrimaryButton(
                    onPressed: widget.selectedServices.isEmpty
                        ? null
                        : () => _showCheckoutDialog(context, ref),
                    label: "Checkout",
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
