class TransactionModel {

  final String amount; // never null, initialized on "new transaction"
  final String senderName; // never null, initialized on "new transaction"
  final String receiverName; // never null, initialized on "new transaction"
  final dynamic time; // never null, initialized on "new transaction"
  final String type; // never null, initialized on "new transaction"

  TransactionModel({
    required this.amount,
    required this.senderName,
    required this.receiverName,
    required this.time,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'senderName': senderName,
      'receiverName': receiverName,
      'time': time,
      'type': type
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> transactionMap) {

    return TransactionModel(
      amount: transactionMap['amount'],
      senderName: transactionMap['senderName'],
      receiverName: transactionMap['receiverName'],
      time: transactionMap['time'],
      type: transactionMap['type']
    );
  }
}