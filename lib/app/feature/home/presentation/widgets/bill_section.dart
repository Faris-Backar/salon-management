import 'package:flutter/material.dart';

class BillSection extends StatelessWidget {
  final List<Map<String, dynamic>> selectedServices;
  final String shopName;
  final String shopLogo;
  final String contactNumber;
  final String email;
  final String address;
  final double gstRate;
  final String slogan;

  const BillSection({
    super.key,
    required this.selectedServices,
    required this.shopName,
    required this.shopLogo,
    required this.contactNumber,
    required this.email,
    required this.address,
    this.gstRate = 18.0,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context) {
    double subtotal =
        selectedServices.fold(0, (sum, service) => sum + service["price"]);
    double gstAmount = subtotal * (gstRate / 100);
    double total = subtotal + gstAmount;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShopHeader(),
          const Divider(thickness: 2),
          _buildBillDetails(),
          const Divider(thickness: 2),
          _buildTotalAmount(subtotal, gstAmount, total),
          const SizedBox(height: 10),
          Center(
            child: Text(
              slogan,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopHeader() {
    return Column(
      children: [
        Image.asset(
          shopLogo,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shopName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text("📍 $address", textAlign: TextAlign.center),
        Text("📞 $contactNumber | ✉️ $email", textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildBillDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Sl. No", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Service", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        Column(
          children: List.generate(selectedServices.length, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${index + 1}"),
                Text(selectedServices[index]["name"]),
                Text("₹${selectedServices[index]["price"]}"),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTotalAmount(double subtotal, double gstAmount, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Subtotal: ₹${subtotal.toStringAsFixed(2)}"),
        Text("GST ($gstRate%): ₹${gstAmount.toStringAsFixed(2)}"),
        Text(
          "Total: ₹${total.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
