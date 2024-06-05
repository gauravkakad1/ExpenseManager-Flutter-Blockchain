class TransactionModel {
  final String address;
  final int amount;
  final String reason;
  final DateTime timestamp;
  final bool isWithdraw;

  TransactionModel(
      this.address, this.amount, this.reason, this.timestamp, this.isWithdraw);
}
