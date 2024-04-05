// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ip_banking_mobile/features/authentication/firebase_methods.dart';
import 'package:ip_banking_mobile/features/authentication/screens/landing_pages/wrong_pin.dart';
import 'package:ip_banking_mobile/features/bottom_navigation_bar.dart';
import 'package:ip_banking_mobile/utilities/animation/slideright_toleft.dart';
import 'package:ip_banking_mobile/utilities/constants.dart';

class EnterPin extends StatefulWidget {

  final String? email;
  final String? password;

  const EnterPin({super.key, this.email, this.password});

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {

  String title = 'Enter your PIN code';
  String subtitle = '';
  String inputPin = '';
  int numberOfTries = 3;

  void resetProcess() {
    setState(() {
      numberOfTries -= 1;

      if (numberOfTries > 0) {
        subtitle = 'Incorrect PIN';
        inputPin = '';
        Navigator.pop(context);
      } else {

        if (widget.email == null && widget.password == null) {
          FirebaseAuth.instance.signOut();
        }
        Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const WrongPin()), (Route<dynamic> route) => false);
      }
    });
  }

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return InkWell(
        onTap: () async {

          if (inputPin.length < 4) {
            setState(() {
              inputPin += number.toString();
            });
          }

          if (inputPin.length == 4) {

            loadingDialog(context);

            User? user = FirebaseAuth.instance.currentUser;
            String userPin = (user == null) ? await getUserPin(identifier: 'email', value: widget.email!)
                                            : await getUserPin(identifier: 'uid', value: user.uid);

            if (inputPin == userPin) {

              if (user == null) {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: widget.email!,
                  password: widget.password!,
                );
              }
              
              Navigator.of(context).pushAndRemoveUntil(SlideRightToLeft(page: const BottomNavBar()), (Route<dynamic> route) => false);
            } else {
              resetProcess();
            }
          }
        },

        splashColor: Colors.transparent,
        highlightColor: mainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(40),

        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mainColor.withOpacity(0.05),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
          physics: const BouncingScrollPhysics(),
          children: [

            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  // fontWeight: FontWeight.w500,
                  fontFamily: "DMSans"
                ),
              ),
            ),

            const SizedBox(height: 60),

            Center(
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  // fontWeight: FontWeight.w600,
                  fontFamily: "DMSans",
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// pin code area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: index < inputPin.length
                          ? mainColor
                          : mainColor.withOpacity(0.1),
                    ),
                    child: null,
                  );
                },
              ),
            ),

            const SizedBox(height: 80),

            /// digits
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),

            /// 0 digit with back remove
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const InkWell(onTap: null, child: SizedBox(width: 80, height: 80,)),
                  numButton(0),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          if (inputPin.isNotEmpty) {
                            inputPin = inputPin.substring(0, inputPin.length - 1);
                          }
                        },
                      );
                    },

                    splashColor: Colors.transparent, // Remove default splash effect
                    highlightColor: mainColor.withOpacity(0.2), // Custom highlight color, slightly darker
                    borderRadius: BorderRadius.circular(40), // Half of width/height for perfect circle

                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.backspace,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
