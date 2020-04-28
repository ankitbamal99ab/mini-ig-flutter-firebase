import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  bool _isLoading = true;
  Firestore _db = Firestore.instance;

  List<DocumentSnapshot> posts;

  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot snap = await _db.collection("posts").orderBy("date", descending: true).getDocuments();
      setState(() {
        posts = snap.documents;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Container(
        child: LinearProgressIndicator(),
      );
    } else {
      return Container(
        child: RefreshIndicator(
          onRefresh: (){

            _fetchPosts();

            return null;
          },
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, i) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Color(0x22000000),
                      offset: Offset(0,4),
                    ),
                  ]
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10, 
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5, 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    Text(posts[i].data["name"]),
                    SizedBox(height: 5,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage(
                        placeholder: AssetImage("assets/placeholder.png"),
                        image: NetworkImage(posts[i].data["photoUrl"]),
                      ),
                    ),
                    SizedBox(height: 5,),
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [

                          TextSpan(
                            text: posts[i].data["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " ${posts[i].data["caption"]}",
                          ),

                        ]
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}