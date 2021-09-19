import 'package:chat/screens/friends_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/custom_widgets.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:collection/collection.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'ChatScreen';
  static late String friendUsername;
  static late String friendEmail;
  static late String myUsername;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      loggedInUser = _auth.currentUser!;
    });
  }

  final _auth = FirebaseAuth.instance;
  late final User loggedInUser;
  late final _firestore = FirebaseFirestore.instance;
  late DateTime time;
  late String message;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ChatLogo(chatFontSize: 0),
            Center(
              child: Text(
                ChatScreen.friendUsername,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[400]),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.perm_contact_cal,
                size: 35,
              ),
              onPressed: () {
                Navigator.pushNamed(context, FriendsScreen.id);
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Container(
            color: Colors.white60,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection(
                      'messages of ${(ChatScreen.friendUsername.codeUnits.sum + ChatScreen.myUsername.codeUnits.sum)}')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs.reversed;
                  List<Widget> messagesList = [];
                  for (var message in messages) {
                    final messageText = message.get('message');
                    final messageSender = message.get('sender');
                    late final messageWidget;
                    if (messageSender == ChatScreen.myUsername) {
                      messageWidget = Container(
                        margin: EdgeInsets.all(7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(messageSender),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blueAccent,
                              ),
                              child: Text(
                                '$messageText',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else if (messageSender != ChatScreen.myUsername) {
                      messageWidget = Container(
                        margin: EdgeInsets.all(7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(messageSender),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blueGrey,
                              ),
                              child: Text(
                                '$messageText',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    messagesList.add(messageWidget);
                  }
                  return ListView(
                    children: messagesList,
                  );
                } else {
                  return LoadingOverlay(
                    isLoading: true,
                    child: Container(color: Colors.blueGrey),
                  );
                }
              },
            ),
          )),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextField(
                  controller: textController,
                  onChanged: (value) {
                    message = value;
                    time = DateTime.now();
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  textController.clear();
                  _firestore
                      .collection(
                          'messages of ${(ChatScreen.friendUsername.codeUnits.sum + ChatScreen.myUsername.codeUnits.sum)}')
                      .add({
                    'message': message,
                    'sender': ChatScreen.myUsername,
                    'receiver': ChatScreen.friendUsername,
                    'time': time
                  });
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
