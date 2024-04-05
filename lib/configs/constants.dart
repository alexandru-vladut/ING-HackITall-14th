import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


String appName = 'ing-mobile';
bool emailVerificationEnabled = false;
bool pinEnabled = false;

const Color mainColor = Color(0xFF000089);

var logger = Logger(printer: PrettyPrinter(),);

void loadingDialog(BuildContext context) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.loading,
    text: 'Loading...',
    barrierDismissible: false,
  );
}

void successDialog(BuildContext context, String message) {
  CoolAlert.show(
    context: context,
    barrierDismissible: false,
    type: CoolAlertType.success,
    backgroundColor: Colors.greenAccent.withOpacity(0.1),
    confirmBtnColor: const Color.fromARGB(255, 73, 186, 143),
    confirmBtnText: 'OK',
    title: message,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
    )
  );
}

void errorDialog(BuildContext context, String message) {
  Navigator.pop(context); // close loadingDialog()
  CoolAlert.show(
    context: context,
    barrierDismissible: false,
    type: CoolAlertType.error,
    backgroundColor: Colors.redAccent.withOpacity(0.1),
    confirmBtnColor: Colors.redAccent,
    confirmBtnText: 'OK',
    title: message,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
    )
  );
}

const kMainColor = Color(0xFFFCFCFC);
const kSecondaryColor = Color(0xff15c682);
const kBlueColor = Color(0xFF7A60EB);
const kGreyDarkColor = Color(0xFF666666);
const kBlackColor = Color(0xFF1A1B23);
const kBlueDarkColor = Color(0xFF01004A);
const kGreenLightColor = Color(0xFF80D261);
const kGreenColor = Color(0xFF32BA7C);
const kOrangeLightColor = Color(0xFFF9EAB0);
const kGreyBottomColor = Color(0xFF79869F);
const kBlackLightColor = Color(0xFF656565);
const kYellowColor = Color(0xFFFFBE11);
const kOragneColor = Color(0xFFFF633E);
const kRedColor = Color(0xFFF15249);
const kWhiteLightColor = Color(0xFFFCFCFC);
const kGreyLightColor = Color(0xFFD9D9D9);

Map vendorLogo = {
  'Carrefour': 'assets/vendor_logos/carrefour.png',
  'Nike': 'assets/vendor_logos/nike.png',
  'Starbucks': 'assets/vendor_logos/starbucks.png',
  'IKEA': 'assets/vendor_logos/ikea.png',
  'H&M': 'assets/vendor_logos/hm.png',
  
  'Asociaţia Copacul de Hârtie': 'assets/env/a1.png',
  'Asociaţia Sudcarpatica': 'assets/env/a2.png',
  'Asociaţia Ecosophia': 'assets/env/a4.png',
  'Asociaţia Slow Food': 'assets/env/a3.png',
  'Asociaţia Rara Avis': 'assets/env/a1.png',
  'Asociaţia EcoLogic': 'assets/env/a2.png',
  };

Map envLogo = {
  'Asociaţia Copacul de Hârtie': 'assets/env/a1.png',
  'Asociaţia Sudcarpatica': 'assets/env/a2.png',
  'Asociaţia Ecosophia': 'assets/env/a4.png',
  'Asociaţia Slow Food': 'assets/env/a3.png',
  'Asociaţia Rara Avis': 'assets/env/a1.png',
  'Asociaţia EcoLogic': 'assets/env/a2.png',
};

void getUserDetails(User user, List<String> userDetails, List<String> fields, Function() onCompletion) async {

  final userCollection = await FirebaseFirestore.instance.collection('users').where('UID', isEqualTo: user.uid).get();
  final userDoc = userCollection.docs[0];

  for (int i = 0; i < userDetails.length; i++) {
    userDetails[i] = userDoc.get(fields[i]).toString();
  }

  onCompletion();
}

void getCreditCardDetails(User user, List<String> creditCardDetails, List<bool> hasCard, Function() onCompletion) async {

  final userCollection = await FirebaseFirestore.instance.collection('users').where('UID', isEqualTo: user.uid).get();
  final userDoc = userCollection.docs[0];

  if (userDoc.get("creditCard") == null) {
    hasCard[0] = false;
  } else {
    hasCard[0] = true;
    creditCardDetails[0] = userDoc.get("creditCard")["cvv"].toString();
    creditCardDetails[1] = userDoc.get("creditCard")["expirationDate"].toString();
    creditCardDetails[2] = userDoc.get("creditCard")["name"].toString();
    creditCardDetails[3] = userDoc.get("creditCard")["number"].toString();
    creditCardDetails[4] = userDoc.get("creditCard")["type"].toString();
    creditCardDetails[5] = userDoc.get("creditCard")["sold"].toString();
  }

  onCompletion();
}

void getEcoCardDetails(User user, List<String> ecoCardDetails, Function() onCompletion) async {

  final userCollection = await FirebaseFirestore.instance.collection('users').where('UID', isEqualTo: user.uid).get();
  final userDoc = userCollection.docs[0];

  if (userDoc.get("ecoCard") != null) {
    ecoCardDetails[0] = userDoc.get("ecoCard")["cvv"].toString();
    ecoCardDetails[1] = userDoc.get("ecoCard")["expirationDate"].toString();
    ecoCardDetails[2] = userDoc.get("ecoCard")["name"].toString();
    ecoCardDetails[3] = userDoc.get("ecoCard")["number"].toString();
    ecoCardDetails[4] = userDoc.get("ecoCard")["sold"].toString();
  }

  onCompletion();
}
