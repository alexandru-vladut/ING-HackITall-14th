import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ing_mobile/models/card.dart';
import 'package:ing_mobile/models/transaction.dart';

class UserModel {
  
  final String? docId; // may be null, documentId from Firestore Collection (null when creating instance)
  final String uid; // never null, initialized on register
  final String name; // never null, initialized on register
  final String email; // never null, initialized on register
  final String? pin; // may be null, initialized with null on register
  final CardModel? creditCard; // may be null, initialized with null on register
  final CardModel? ecoCard; // may be null, initialized with null on register
  final List<TransactionModel> transactions; // never null, initialized with [] (empty list) on register
  
  UserModel({
    this.docId,
    required this.uid,
    required this.name,
    required this.email,
    this.pin,
    this.creditCard,
    this.ecoCard,
    required this.transactions
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'pin': pin,
      'creditCard': (creditCard != null) ? creditCard!.toMap() : null,
      'ecoCard': (ecoCard != null) ? ecoCard!.toMap() : null,
      'transactions': transactions.map((e) => e.toMap()).toList()
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    
    Map data = doc.data()!;

    return UserModel(
      docId: doc.id,
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      pin: data['pin'],
      creditCard: CardModel.fromMap(data['creditCard']),
      ecoCard: CardModel.fromMap(data['ecoCard']),
      transactions: (data['transactions'] as List<Map<String, dynamic>>).map((e) => TransactionModel.fromMap(e)).toList()
    );
  }
}