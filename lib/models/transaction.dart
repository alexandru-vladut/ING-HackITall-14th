import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {

  final String? docId;
  final int value;
  final String userUid;
  final dynamic timestamp;
  final String type;
  final String? voucherId;

  TransactionModel({
    this.docId,
    required this.value,
    required this.userUid,
    required this.timestamp,
    required this.type,
    required this.voucherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'Value': value,
      'UserUid': userUid,
      'Timestamp': timestamp,
      'Type': type,
      'VoucherId': voucherId,
    };
  }

  factory TransactionModel.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {

    Map data = doc.data()!;

    return TransactionModel(
      docId: doc.id,
      value: data['Value'],
      userUid: data['UserUid'],
      timestamp: data['Timestamp'],
      type: data['Type'],
      voucherId: data['VoucherId'],
    );
  }
}