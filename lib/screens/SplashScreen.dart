import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_ig/screens/HomeScreen.dart';
import 'package:mini_ig/screens/LoginScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data != null) {

            // if user is signed in
            return HomeScreen();

          } else {
            // if user is not signed in
            return LoginScreen();
          }
        }

        // if user is not signed in
        return LoginScreen();
      },
    );
  }
}