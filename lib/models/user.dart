import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  
  final String? docId; // may be null, documentId from Firestore Collection (null when creating instance)
  final String uid; // never null, initialized on register
  final String name; // never null, initialized on register
  final String email; // never null, initialized on register
  final int totalPoints;
  final String companyId;
  
  UserModel({
    this.docId,
    required this.uid,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'Uid': uid,
      'Name': name,
      'Email': email,
      'TotalPoints': totalPoints,
      'CompanyId': companyId,
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    
    Map data = doc.data()!;

    return UserModel(
      docId: doc.id,
      uid: data['Uid'],
      name: data['Name'],
      email: data['Email'],
      totalPoints: data['TotalPoints'],
      companyId: data['CompanyId'],
    );
  }
}