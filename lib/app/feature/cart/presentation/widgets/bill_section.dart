// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salon_management/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/cart/presentation/notifiers/cart/cart_notifier.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/customer/presentation/providers/customer_provider.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/settings/data/services/shop_details_service.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';

class BillSection extends ConsumerStatefulWidget {
  final List<ServiceItemEntity> selectedServices;
  final double totalAmount;
  final VoidCallback onClearBill;
  final Function(double, String) onCheckout;

  const BillSection({
    required this.selectedServices,
    required this.totalAmount,
    required this.onClearBill,
    required this.onCheckout,
    super.key,
  });

  @override
  ConsumerState<BillSection> createState() => _BillSectionState();
}

class _BillSectionState extends ConsumerState<BillSection> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = "CASH";
  String? selectedCustomerName;
  String? selectedCustomerPhone;
  CustomerEntity? selectedCustomer;
  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toStringAsFixed(2);
  }

  void _showCheckoutDialog(BuildContext context) {
    bool sendToWhatsApp = false;
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController amountController =
        TextEditingController(text: widget.totalAmount.toStringAsFixed(2));
    String customerNameLabel = "";

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
                    const Text("Customer Mobile Number:"),
                    TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onChanged: (value) async {
                        if (value.length == 10) {
                          final customers = await ref
                              .read(customerNotifierProvider.notifier)
                              .searchCustomerByPhone(value);
                          setDialogState(() {
                            if (customers.isNotEmpty) {
                              customerNameLabel =
                                  "Existing Customer: ${customers.first.name}";
                              selectedCustomer = customers.firstOrNull;
                              final cartState =
                                  ref.read(cartNotifierProvider.notifier);
                              if (selectedCustomer != null) {
                                cartState.setCustomerDetails(selectedCustomer!);
                              }
                            } else {
                              customerNameLabel = "New Customer";
                              selectedCustomer = null;
                            }
                          });
                        } else {
                          setDialogState(() {
                            customerNameLabel = "";
                            selectedCustomerName = null;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter mobile number",
                        counterText: "",
                      ),
                    ),
                    if (customerNameLabel.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          customerNameLabel,
                          style: TextStyle(
                            color: customerNameLabel.startsWith("Existing")
                                ? context.colorScheme.primary
                                : context.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
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
                                        .withValues(alpha: 0.2)
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
                                        .withValues(alpha: 0.2)
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
                  onPressed: () async {
                    double enteredAmount =
                        double.tryParse(amountController.text) ??
                            widget.totalAmount;
                    String mobileNumber = mobileController.text.trim();

                    if (mobileNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter mobile number")),
                      );
                      return;
                    }
                    log("customer selected $selectedCustomer");
                    if (selectedCustomer == null) {
                      selectedCustomer = CustomerEntity(
                        uid: const Uuid().v8(),
                        name: "Guest",
                        mobileNumber: mobileNumber,
                        address: "",
                      );
                      await ref
                          .read(customerNotifierProvider.notifier)
                          .createcustomer(customer: selectedCustomer!);
                    }

                    // Set customer details in cart state
                    log("Setting customer in cart: $selectedCustomer");
                    ref
                        .read(cartNotifierProvider.notifier)
                        .setCustomerDetails(selectedCustomer!);

                    // Verify customer was set
                    final cartState = ref.read(cartNotifierProvider);
                    log("Cart state after setting customer: ${cartState.customer}");

                    // Close dialog first to trigger rebuild
                    Navigator.pop(context);

                    // Then process checkout
                    widget.onCheckout(enteredAmount, _selectedPaymentMethod);

                    if (sendToWhatsApp) {
                      _sendBillToWhatsApp(enteredAmount,
                          selectedCustomer?.name ?? "Guest", mobileNumber);
                    }
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

  void _sendBillToWhatsApp(
      double amount, String customerName, String customerPhone) async {
    final shopDetails = ref.read(shopDetailsStreamProvider).value;

    try {
      // Format the message
      final message = """
*${shopDetails?.name ?? 'My Salon'}*
${shopDetails?.address ?? ''}
Contact: ${shopDetails?.mobileNumber ?? ''}
${shopDetails?.email?.isNotEmpty == true ? 'Email: ${shopDetails?.email}\n' : ''}

------------------
*Invoice #TEMP*
Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
Customer: $customerName
Mobile: $customerPhone

*Items:*
${widget.selectedServices.asMap().entries.map((entry) => "${entry.value.name}: ₹${entry.value.price}").join("\n")}

*Total: ₹${amount.toStringAsFixed(2)}*
Payment Method: $_selectedPaymentMethod

Thank you for your business!
Visit us again soon.
""";

      // Format the phone number
      String phoneNumber = customerPhone;
      // Remove any non-digit characters
      phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      // Add country code if not present
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '91$phoneNumber'; // Add Indian country code
      }
      // Remove + if present
      phoneNumber = phoneNumber.replaceAll('+', '');

      final url = Uri.parse(
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Could not open WhatsApp. Please make sure WhatsApp is installed."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Unable to open WhatsApp. Please try again."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showUpdateAmountDialog(
      BuildContext context, ServiceItemEntity service, int index) {
    final TextEditingController amountController =
        TextEditingController(text: service.price);
    final TextEditingController remarkController =
        TextEditingController(text: service.remark);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Amount for ${service.name}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "₹ ",
                    border: OutlineInputBorder(),
                    labelText: "New Amount",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Remark (Optional)",
                    alignLabelWithHint: true,
                  ),
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
                final newAmount = double.tryParse(amountController.text);
                if (newAmount != null && newAmount >= 0) {
                  final updatedService = ServiceItemEntity(
                    uid: service.uid,
                    name: service.name,
                    price: newAmount.toStringAsFixed(2),
                    categoryName: service.categoryName,
                    categoryUid: service.categoryUid,
                    isActive: service.isActive,
                    remark: remarkController.text.trim().isEmpty
                        ? null
                        : remarkController.text.trim(),
                  );
                  ref
                      .read(cartNotifierProvider.notifier)
                      .updateService(index, updatedService);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter a valid amount")),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopDetailsAsyncValue = ref.watch(shopDetailsStreamProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final customerName = cartState.customer?.name ?? "Guest";
    final customerPhone = cartState.customer?.mobileNumber ?? "N/A";
    final employeeName = cartState.employee?.fullname ?? "Not Assigned";

    return shopDetailsAsyncValue.when(
      data: (shopDetails) {
        return SafeArea(
          child: Container(
            color: context.colorScheme.surfaceBright,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (shopDetails.logoUrl != null &&
                    shopDetails.logoUrl!.isNotEmpty)
                  Center(
                      child: Image.network(shopDetails.logoUrl!, height: 150))
                else
                  Center(
                      child: Image.asset(Assets.images.logoWithName.path,
                          height: 150)),
                const SizedBox(height: 8),
                Text(shopDetails.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(shopDetails.address),
                Text("Contact: ${shopDetails.mobileNumber}"),
                if (shopDetails.email != null && shopDetails.email!.isNotEmpty)
                  Text("Email: ${shopDetails.email}"),
                const Divider(thickness: 2),
                Text("Customer: $customerName - $customerPhone"),
                Text("Employee: $employeeName"),
                const Divider(thickness: 2),
                const Text("Services:"),
                Expanded(
                  child: ListView.builder(
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
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. ${service.name}"),
                              if (service.remark != null &&
                                  service.remark!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    service.remark!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Text("₹${service.price}"),
                          onTap: () =>
                              _showUpdateAmountDialog(context, service, index),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "Total: ₹${widget.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                if (shopDetails.slogan != null &&
                    shopDetails.slogan!.isNotEmpty)
                  Center(
                    child: Text(shopDetails.slogan!,
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
                    PrimaryButton(
                      onPressed: widget.selectedServices.isEmpty
                          ? null
                          : () => _showCheckoutDialog(context),
                      label: "Checkout",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text("Error loading shop details: $error"),
      ),
    );
  }
}
