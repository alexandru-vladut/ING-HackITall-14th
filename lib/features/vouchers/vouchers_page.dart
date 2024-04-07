// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ing_mobile/models/user.dart';
import 'package:ing_mobile/models/voucher.dart';

class VouchersPage extends StatefulWidget {
  const VouchersPage({Key? key}) : super(key: key);

  @override
  _VouchersPageState createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {

  List<Voucher> voucherModels = [];
  List<Voucher> addedVoucherModels = [];

  final user = FirebaseAuth.instance.currentUser!;

  UserModel? userData;
  int balance = -1;

  void getVouchers() async {
    CollectionReference vouchers = FirebaseFirestore.instance.collection('Vouchers');

    // Query to get users in the same company, ordered by totalPoints
    QuerySnapshot querySnapshot = await vouchers.get();

    voucherModels = querySnapshot.docs
      .map((doc) => Voucher.fromMap(doc as DocumentSnapshot<Map<String, dynamic>>))
      .toList();

    setState(() {});
  }

  void getUserData() async {
    final userCollection = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: user.uid).get();
    final userDoc = userCollection.docs[0];

    userData = UserModel.fromDocumentSnapshot(userDoc);

    balance = userData!.totalPoints;

    setState(() {});
  }

  @override
  void initState() {
    getVouchers();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        title: Text(
          (balance != -1) ? 'Vouchers - Points: ${balance}' : 'Vouchers - Points:',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          if (addedVoucherModels.isNotEmpty) ...[
            const Divider(),
            const Text(
              "Selected",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: addedVoucherModels.map((voucher) {
                return jobComponent(voucher: voucher, isAdded: true);
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          if (voucherModels.isNotEmpty) ...[
            const Text(
              "Available",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: voucherModels.map((voucher) {
                return jobComponent(voucher: voucher, isAdded: false);
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }

  Widget jobComponent({required Voucher voucher, required bool isAdded}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      (voucher.partner == 'Altex') ? 'assets/images/altex.png' :
                      (voucher.partner == 'Ivelo') ? 'assets/images/velo.png' :
                      (voucher.partner == 'Tazz') ? 'assets/images/tazz.png' :
                      'assets/images/nespresso.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        voucher.description,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15,),
          Column(
            children: [
              Text(
                voucher.cost.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Pts',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isAdded) {
                      addedVoucherModels.remove(voucher);
                      voucherModels.insert(0, voucher);
                      balance += voucher.cost;
                    } else {
                      addedVoucherModels.insert(0, voucher);
                      voucherModels.remove(voucher);
                      balance -= voucher.cost;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAdded ? Colors.red : Colors.green,
                  ),
                  child: Icon(
                    isAdded ? Icons.remove : Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
