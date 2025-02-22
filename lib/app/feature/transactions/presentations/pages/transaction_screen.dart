import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/transactions/presentations/notifiers/transaction_notifiers.dart';

@RoutePage()
class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  Future<void> _selectDate(
      BuildContext context, WidgetRef ref, bool isFromDate) async {
    final current = ref.read(isFromDate ? fromDateProvider : toDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      ref
          .read(
              isFromDate ? fromDateProvider.notifier : toDateProvider.notifier)
          .state = picked;
    }
  }

  Future<void> _generatePDF(List transactions, double totalAmount) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Salon Transactions",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Address: 123 Salon Street, City, Country"),
              pw.Text("Phone: +123 456 7890"),
              pw.Divider(),
              pw.Table.fromTextArray(
                headers: [
                  "Sl.No",
                  "Customer Name",
                  "Employee Name",
                  "Date & Time",
                  "Total Amount"
                ],
                data: List.generate(transactions.length, (index) {
                  final transaction = transactions[index];
                  return [
                    index + 1,
                    transaction.customer,
                    transaction.employee,
                    DateFormat('yMMMd – hh:mm a').format(transaction.createdAt),
                    "₹${transaction.totalAmount?.toStringAsFixed(2)}"
                  ];
                }),
              ),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text("Total: ₹${totalAmount.toStringAsFixed(2)}",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    // if (kIsWeb) {
    //   downloadPdfWeb(pdfBytes);
    // } else {
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/transactions.pdf");
    await file.writeAsBytes(pdfBytes);
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final totalAmount = ref.watch(totalAmountProvider);
    final fromDate = ref.watch(fromDateProvider);
    final toDate = ref.watch(toDateProvider);

    return Scaffold(
      appBar: Responsive.isMobile()
          ? AppBar(
              title: const Text("Transactions"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    transactionsAsync.whenData((transactions) {
                      _generatePDF(transactions, totalAmount);
                    });
                  },
                ),
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectDate(context, ref, true),
                  child: Text("From: ${DateFormat.yMMMd().format(fromDate)}"),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, ref, false),
                  child: Text("To: ${DateFormat.yMMMd().format(toDate)}"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Transactions List in Cards
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text("No Transactions Found"));
                  }
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: context.colorScheme.tertiaryContainer,
                        child: ListTile(
                          leading: Text("${index + 1}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          title: Text(transaction.customer,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              DateFormat.yMMMd().format(transaction.createdAt)),
                          trailing: Text(
                            "₹${transaction.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),

            const SizedBox(height: 10),

            // Total Amount
            Text(
              "Total: ₹${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
