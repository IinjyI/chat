import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../custom_widgets.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static const String id = 'FriendsScreen';
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late User loggedInUser;
  void getCurrentUser() async {
    final user = await _auth.currentUser;

    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child: ChatLogo(chatFontSize: 20),
              onTap: () {},
            ),
            Text(
              ' Friends',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[400],
                  fontSize: 20),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!.docs;
              List<Widget> friendsList = [];
              for (var user in users) {
                final friend = user.get('user');
                final friendEmail = user.get('email');
                late final FriendWidget;
                if (friendEmail != loggedInUser.email) {
                  FriendWidget = Container(
                    margin: EdgeInsets.all(7),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey[800],
                    ),
                    child: Text(
                      friend,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                  friendsList.add(FriendWidget);
                } else if (friendEmail == loggedInUser.email) {
                  FriendWidget = Container(
                    margin: EdgeInsets.all(7),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey[800],
                    ),
                    child: Text(
                      'You!',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                  friendsList.add(FriendWidget);
                }
              }
              return ListView(
                children: friendsList,
              );
            } else {
              return LoadingOverlay(
                isLoading: true,
                child: Container(color: Colors.blueGrey),
              );
            }
          }),
    );
  }
}
