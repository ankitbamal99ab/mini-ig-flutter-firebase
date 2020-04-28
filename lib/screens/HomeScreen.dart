import 'package:flutter/material.dart';
import 'package:mini_ig/screens/PostImageScreen.dart';
import 'package:mini_ig/screens/pages/FeedPage.dart';
import 'package:mini_ig/screens/pages/ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  var pages = [FeedPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actionsIconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "MINI IG",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            tooltip: "Take a picture",
            icon: Icon(Icons.camera),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostImageScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (i) {
          setState(() {
            currentPage = i;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), title: Text("Feed")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text("Profile")),
        ],
      ),
      body: pages[currentPage],
    );
  }
}
