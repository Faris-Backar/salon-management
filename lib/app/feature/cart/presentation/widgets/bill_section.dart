// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';
import 'package:salon_management/app/feature/widgets/primary_button.dart';

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

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Use StatefulBuilder to manage state within the dialog
            return AlertDialog(
              title: const Text("Checkout"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Amount:"),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: "₹ ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Payment Method:"),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _selectedPaymentMethod = "CASH";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                            ),
                            child: const Center(
                              child: Text("CASH",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _selectedPaymentMethod = "ONLINE";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                            ),
                            child: const Center(
                              child: Text("ONLINE",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    double enteredAmount =
                        double.tryParse(_amountController.text) ??
                            widget.totalAmount;
                    widget.onCheckout(enteredAmount, _selectedPaymentMethod);
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
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
              child: ListView.builder(
                itemCount: widget.selectedServices.length,
                itemBuilder: (context, index) {
                  final service = widget.selectedServices[index];
                  return ListTile(
                    title: Text("${index + 1}. ${service.name}"),
                    trailing: Text("₹${service.price}"),
                  );
                },
              ),
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
                PrimaryButton(
                  onPressed: widget.selectedServices.isEmpty
                      ? null
                      : _showCheckoutDialog,
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
