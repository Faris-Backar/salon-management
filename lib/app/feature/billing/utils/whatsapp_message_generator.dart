import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/feature/billing/domain/entities/invoice_entity.dart';
import 'package:salon_management/app/feature/customer/domain/enitites/customer_entity.dart';
import 'package:salon_management/app/feature/settings/data/services/shop_details_service.dart';
import 'package:salon_management/app/feature/settings/domain/models/shop_details_model.dart';

class WhatsAppMessageGenerator {
  static Future<String> generateBillMessage(
    InvoiceEntity invoice,
    CustomerEntity customer,
    WidgetRef ref,
  ) async {
    final shopDetails = await _getShopDetails(ref);
    final dateFormatter = DateFormat('dd MMM yyyy');
    final currencyFormatter =
        NumberFormat.currency(symbol: AppStrings.indianRupee);

    final items = invoice.items.map((item) {
      return "${item.name} ${item.quantity > 1 ? '(${item.quantity}x)' : ''}: ${currencyFormatter.format(item.price * item.quantity)}";
    }).join("\n");

    final message = '''
*${shopDetails.name}*
${shopDetails.address}
Contact: ${shopDetails.mobileNumber}
${shopDetails.email != null ? 'Email: ${shopDetails.email}\n' : ''}${shopDetails.gstNumber != null ? 'GST: ${shopDetails.gstNumber}\n' : ''}
------------------
*Invoice #${invoice.invoiceNumber}*
Date: ${dateFormatter.format(invoice.createdAt)}
Customer: ${customer.name}

*Items:*
$items

${invoice.discount > 0 ? 'Discount: ${currencyFormatter.format(invoice.discount)}\n' : ''}*Total: ${currencyFormatter.format(invoice.totalAmount)}*

Thank you for your business!
Visit us again soon.
''';

    return message;
  }

  static Future<ShopDetailsModel> _getShopDetails(WidgetRef ref) async {
    try {
      return await ref.read(shopDetailsProvider.future);
    } catch (e) {
      return defaultShopDetails;
    }
  }
}
