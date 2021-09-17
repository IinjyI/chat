import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatLogo extends StatelessWidget {
  ChatLogo({required this.chatFontSize});
  final double chatFontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons8-chat-96.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          'Chat!',
          style: TextStyle(
              fontSize: chatFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400]),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({required this.text, required this.function});
  final String text;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
        child: Text(text,
            style: TextStyle(
              fontSize: 20,
            )),
      ),
    );
  }
}
