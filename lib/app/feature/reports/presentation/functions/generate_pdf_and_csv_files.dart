import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:salon_management/app/feature/reports/presentation/functions/download_functions_web.dart';
import 'package:salon_management/app/feature/transactions/domain/entity/transaction_entity.dart';

void exportToCSV({required List<TransactionEntity> transactions}) {
  List<List<dynamic>> csvData = [
    [
      'SL. NO',
      'CUSTOMER NAME',
      'EMPLOYEE NAME',
      'SERVICES',
      'TOTAL AMOUNT',
      'PAYMENT METHOD',
      'DATE'
    ],
    ...transactions.asMap().entries.map((entry) {
      final index = entry.key;
      final transaction = entry.value;
      return [
        index + 1,
        transaction.customer,
        transaction.employee,
        transaction.selectedServices?.map((s) => s.name).join(', '),
        NumberFormat.currency(symbol: '\$', decimalDigits: 2)
            .format(transaction.totalAmount),
        transaction.paymentMethod,
        DateFormat('yyyy-MM-dd').format(transaction.createdAt),
      ];
    })
  ];
  String csv = const ListToCsvConverter().convert(csvData);
  if (kIsWeb) {
    downloadCSVForWeb(csv: csv);
  } else {
    // Mobile/Desktop file saving (you might want to use path_provider)
    // Implement file saving logic for mobile/desktop
  }
}

Future<void> exportToPDF(
    {required DateTime fromDate,
    required DateTime toDate,
    required List<TransactionEntity> transactions,
    required double totalTransactionAmount}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Transaction Report',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('From: ${DateFormat('yyyy-MM-dd').format(fromDate)} '
            'To: ${DateFormat('yyyy-MM-dd').format(toDate)}'),
        pw.SizedBox(height: 20),
        pw.Table(
            columnWidths: {
              0: pw.FixedColumnWidth(30), // SL.No
              1: pw.FixedColumnWidth(100), // Customer
              2: pw.FixedColumnWidth(100), // Employee
              3: pw.FixedColumnWidth(150), // Services
              4: pw.FixedColumnWidth(80), // Total Amount
            },
            border: pw.TableBorder.all(color: PdfColors.black),
            children: [
              // Bold Header Row
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Text('SL.No',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Customer',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Employee',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Services',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Total Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]),
              // Data Rows
              ...List.generate(transactions.length, (index) {
                final transaction = transactions[index];
                return pw.TableRow(children: [
                  pw.Text('${index + 1}'),
                  pw.Text(transaction.customer?.name ?? ""),
                  pw.Text(transaction.employee?.fullname ?? ""),
                  pw.Text(transaction.selectedServices
                          ?.map((s) => s.name)
                          .join(', ') ??
                      ""),
                  pw.Text(NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                      .format(transaction.totalAmount)),
                ]);
              })
            ]),
        // Footer with total information
        pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Transactions: ${transactions.length}'),
                  pw.Text(
                      'Total Amount: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(totalTransactionAmount)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]))
      ]),
    ),
  );

  if (kIsWeb) {
    await downloadPdfWeb(pdf);
  } else {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
