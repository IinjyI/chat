import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChatLogo(chatFontSize: 20),
            Text(
              ' Friends',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[400],
                  fontSize: 20),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                  _auth.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 7.0),
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ))
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
                late final myUsername;
                if (friendEmail != loggedInUser.email) {
                  FriendWidget = GestureDetector(
                    onTap: () {
                      setState(() {
                        ChatScreen.friendUsername = friend;
                        ChatScreen.friendEmail = friendEmail;
                      });
                      Navigator.pushNamed(context, ChatScreen.id);
                    },
                    child: Container(
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
                    ),
                  );
                  friendsList.add(FriendWidget);
                } else if (friendEmail == loggedInUser.email) {
                  myUsername = user.get('user');
                  ChatScreen.myUsername = myUsername;
                  FriendWidget = Container(
                    margin: EdgeInsets.all(7),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey[800],
                    ),
                    child: Text(
                      '$myUsername (You!)',
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
