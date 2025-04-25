class InvoiceEntity {
  final String uid;
  final String invoiceNumber;
  final String customerId;
  final List<InvoiceItemEntity> items;
  final double totalAmount;
  final double discount;
  final String paymentMethod;
  final DateTime createdAt;

  InvoiceEntity({
    required this.uid,
    required this.invoiceNumber,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.discount,
    required this.paymentMethod,
    required this.createdAt,
  });
}

class InvoiceItemEntity {
  final String name;
  final int quantity;
  final double price;

  InvoiceItemEntity({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
