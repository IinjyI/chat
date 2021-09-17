import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/custom_widgets.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'friends_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'RegisterScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool loading = false;
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Sign up'),
      ),
      body: LoadingOverlay(
        isLoading: loading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'logo',
                child: ChatLogo(
                  chatFontSize: 50,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: LoginButton(
                  text: 'Sign Up',
                  function: () async {
                    setState(() {
                      loading = true;
                    });
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    _firestore
                        .collection('users')
                        .add({'user': username, 'email': email});
                    setState(() {
                      loading = false;
                    });
                    if (newUser != null) {
                      Navigator.pushNamed(context, FriendsScreen.id);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
