import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom_widgets.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static const String id = 'FriendsScreen';
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
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
    );
  }
}
