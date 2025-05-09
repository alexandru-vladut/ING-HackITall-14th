import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ing_mobile/features/authentication/screens/login.dart';
import 'package:ing_mobile/features/bottom_navigation_bar.dart';

class CheckLoginStatus extends StatelessWidget {
  const CheckLoginStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: returnPageBasedOnLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Return the appropriate page based on the snapshot data
          return snapshot.data!;
        } else {
          // Show a loading spinner while waiting for the future to complete
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

Future<Widget> returnPageBasedOnLoginStatus() async {

  User? user = FirebaseAuth.instance.currentUser;
  
  if (user == null) {

    return const LoginPage();

  } else {

    return const BottomNavBar();

  }
}
