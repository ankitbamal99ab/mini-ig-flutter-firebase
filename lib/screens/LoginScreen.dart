import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {


  void doGoogleSignIn() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      // store user data
      Firestore.instance
        .collection("users")
        .document(user.uid)
        .setData({
          "email": user.email,
          "displayName": user.displayName,
          "photoUrl": user.photoUrl,
          "lastLogin": DateTime.now()
        });

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: Text(
            "MINI IG",
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
            bottom: 80, 
          ),
          child: GoogleSignInButton(
            onPressed: () {
              doGoogleSignIn();
            },
          ),
        )
      ],
    ));
  }
}
