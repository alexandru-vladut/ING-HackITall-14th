// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ing_mobile/features/bottom_navigation_bar.dart';
import 'package:ing_mobile/utilities/animation/slideright_toleft.dart';

import 'package:ing_mobile/configs/constants.dart';


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

      Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const BottomNavBar()), (Route<dynamic> route) => false);
      
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

    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (var doc in snapshot.docs) {
      if (doc.data()['Email'].toString() == email) {
        return true;
      }
    }
    return false;
    
  } catch (error) {
    logger.e(error.toString());
    return null;
  }
}
