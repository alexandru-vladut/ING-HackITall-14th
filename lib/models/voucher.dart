import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {

  final int cost;
  final String description;
  final String name;
  final String partner;

  Voucher({
    required this.cost,
    required this.description,
    required this.name,
    required this.partner,
  });

  Map<String, dynamic> toMap() {
    return {
      'Cost': cost,
      'Description': description,
      'Name': name,
      'Partner': partner,
    };
  }

  factory Voucher.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {

    Map data = doc.data()!;

    return Voucher(
      cost: data['Cost'],
      description: data['Description'],
      name: data['Name'],
      partner: data['Partner'],
    );
  }
}