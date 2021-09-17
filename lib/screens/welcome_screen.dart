import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/custom_widgets.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Hero(
                tag: 'logo',
                child: ChatLogo(
                  chatFontSize: 50,
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginButton(
                  function: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  text: 'Sign in',
                ),
                LoginButton(
                  function: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                  text: 'Sign up',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
