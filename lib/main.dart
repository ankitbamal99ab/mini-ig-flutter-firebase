import 'package:flutter/material.dart';
import 'package:mini_ig/screens/SplashScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        fontFamily: "poppins",
        primaryColor: Color(0xFFd35400),
      ),
    );
  }
}