import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name;

  String photoUrl;

  bool isLoaded = false;

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    try {
      FirebaseUser user = await _auth.currentUser();

      DocumentSnapshot doc =
          await _db.collection("users").document(user.uid).get();

      setState(() {
        isLoaded = true;
        name = doc.data["displayName"];
        photoUrl = doc.data["photoUrl"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isLoaded) {
      return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(170),
                child: Image(
                  image: NetworkImage(photoUrl),
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

          Text(
            name,
            style: TextStyle(
              fontSize: 30
            ),
          ),

          RaisedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
    } else {
      return Container(
        child: Center(child: Text("Loading"),),
      );
    }
  }
}
