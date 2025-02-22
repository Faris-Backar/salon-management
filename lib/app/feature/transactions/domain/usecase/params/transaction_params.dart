class TransactionParams {
  final DateTime fromDate;
  final DateTime toDate;

  TransactionParams({required this.fromDate, required this.toDate});

  @override
  String toString() =>
      'TransactionParams(fromDate: $fromDate, toDate: $toDate)';
}
