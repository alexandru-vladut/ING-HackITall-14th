// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ip_banking_mobile/features/authentication/screens/enter_pin.dart';
import 'package:ip_banking_mobile/features/authentication/screens/landing_pages/forget_email_sent.dart';
import 'package:ip_banking_mobile/features/authentication/screens/landing_pages/verification_email_sent.dart';
import 'package:ip_banking_mobile/features/authentication/screens/create_pin.dart';
import 'package:ip_banking_mobile/features/bottom_navigation_bar.dart';
import 'package:ip_banking_mobile/utilities/animation/slideright_toleft.dart';
import 'package:ip_banking_mobile/utilities/constants.dart';

void signUserIn(BuildContext context, String email, String password) async {

  loadingDialog(context);

  try {
    // 1. Check data with FirebaseAuth (validate email and password)
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Check if user exists in 'users' collection based on it's email
    // (A user may not exist in 'users' collection if the account was disabled - deleted data)
    bool? isUserInFirestoreCollection = await userInFirestoreCollection(email);
    if (isUserInFirestoreCollection == true) {

      User user = FirebaseAuth.instance.currentUser!;

      if (user.emailVerified) {
        
        final userCollection = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user.uid).get();
        final userDoc = userCollection.docs[0];
        String? userPin = userDoc.get('pin');

        FirebaseAuth.instance.signOut();

        if (userPin == null) {
          // redirect to 'Set PIN' page
          Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: CreatePin(email: email, password: password)), (Route<dynamic> route) => false);
        } else {
          // redirect to 'Enter PIN' page
          Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: EnterPin(email: email, password: password)), (Route<dynamic> route) => false);
        }

      } else {
        await user.sendEmailVerification();
        FirebaseAuth.instance.signOut();

        // Navigare catre pagina de 'Email Verification Sent' care trebuie sa aiba si redirect catre 'Login Page'
        Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const VerificationEmailSent()), (Route<dynamic> route) => false);
      }
      
    } else if (isUserInFirestoreCollection == false) {
      FirebaseAuth.instance.signOut();
      errorDialog(context, 'Contul nu e in Firestore Database.');
      logger.w('Contul nu e in Firestore Database.');
    } else {
      FirebaseAuth.instance.signOut();
      errorDialog(context, 'Unexepcted error, check logger!');
    }
    
  } on FirebaseAuthException catch (error) {
    if (error.code == 'user-not-found' || error.code == 'wrong-password') {
      errorDialog(context, 'Email/parolă greșite!');
      logger.w(error.toString());
    } else {
      errorDialog(context, error.toString());
      logger.e(error.toString());
    }
  }
}

Future<bool?> userInFirestoreCollection(String email) async {

  try {

    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      if (doc.data()['email'].toString() == email) {
        return true;
      }
    }
    return false;
    
  } catch (error) {
    logger.e(error.toString());
    return null;
  }
}

Future<void> sendPasswordResetEmail(BuildContext context, String email) async {

  Navigator.pop(context);
  loadingDialog(context);

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    logger.i('Email reset SUCCESSFUL!');
    Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const ForgetEmailSent()), (Route<dynamic> route) => false);
    
  } catch (error) {
    errorDialog(context, error.toString());
    logger.e(error.toString());
  }
}

void signUserUp(BuildContext context, String inputEmail, String inputName, String inputPassword, String inputConfirmPassword) async {

    loadingDialog(context);

    try {
      // 1. Check if password and confirmPassword fields corespond.
      if (inputPassword == inputConfirmPassword) {
        
        // 2. Check data with FirebaseAuth (validate email and password)
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: inputEmail,
          password: inputPassword
        );
    
        await FirebaseFirestore.instance.collection('users').add({
          'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
          'name': inputName,
          'email': inputEmail,
          'pin': null,
          'creditCard': null,
          'ecoCard': null,
          'transactions': [],
        });

        User user = userCredential.user!;
        await user.updateDisplayName(inputName);
        await user.reload();

        await user.sendEmailVerification();
        FirebaseAuth.instance.signOut();

        logger.i('Sign Up SUCCESSFUL!');

        // Navigare catre pagina de 'Email Verification Sent' care trebuie sa aiba si redirect catre 'Login Page'
        Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const VerificationEmailSent()), (Route<dynamic> route) => false);

      } else {
        errorDialog(context, 'Parolele nu corespund!');
        logger.w('Parolele nu corespund!');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        errorDialog(context, 'Parolă prea slabă!\n (min. 6 caractere)');
        logger.w(error.toString());
      } else if (error.code == 'email-already-in-use') {
        errorDialog(context, 'Adresă de email deja existentă!');
        logger.w(error.toString());
      } else {
        errorDialog(context, error.toString());
        logger.e(error.toString());
      }
    }
  }

Future<void> createPinCode(BuildContext context, String email, String password, String pin) async {

  loadingDialog(context);
              
  final querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
  final queryDocumentSnapshots = querySnapshot.docs;
  await queryDocumentSnapshots.first.reference.update({
    'pin': pin,
  });
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const BottomNavBar()), (Route<dynamic> route) => false);
}

Future<String> getUserPin({required String identifier, required String value}) async {

  final querySnapshot = await FirebaseFirestore.instance.collection('users').where(identifier, isEqualTo: value).get();
  final queryDocumentSnapshot = querySnapshot.docs[0];
  String userPin = queryDocumentSnapshot.get('pin');

  return userPin;
}
