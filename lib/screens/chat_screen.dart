import 'package:chat/screens/friends_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/custom_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getFriends();
  }

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  void getCurrentUser() async {
    final user = await _auth.currentUser;

    if (user != null) {
      loggedInUser = user;
    }
  }

  final _firestore = FirebaseFirestore.instance;
  static String snapshot = '';
  Future<String> getFriends() async {
    final data =
        await _firestore.collection('users').doc('yK2sZENWGdfOuXaTQ8Dj').get();
    setState(() {
      snapshot = data['user'].toString();
    });
    await for (var snapshot in _firestore.collection('Users').snapshots()) {
      for (var friend in snapshot.docs) {
        print(friend.data()['user']);
      }
    }
    return snapshot;
  }

  late String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: ChatLogo(chatFontSize: 0),
              onTap: () {
                print(snapshot);
              },
            ),
            Text(
              snapshot,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[400]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 55),
              child: GestureDetector(
                child: Icon(
                  Icons.perm_contact_cal,
                  size: 35,
                ),
                onTap: () {
                  Navigator.pushNamed(context, FriendsScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Container(color: Colors.white60)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    message = value;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  print(message);
                },
                icon: Icon(Icons.arrow_forward_outlined),
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
