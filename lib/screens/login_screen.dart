import 'package:chat/custom_widgets.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'friends_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Sign in'),
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
                  text: 'Sign In',
                  function: () async {
                    setState(() {
                      loading = true;
                    });
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
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
