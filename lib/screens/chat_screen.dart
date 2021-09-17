import 'package:chat/screens/friends_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/custom_widgets.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'ChatScreen';
  static late String friendUsername;
  static late String friendEmail;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
  static String user = '';

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
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  List<Widget> messagesList = [];
                  for (var message in messages) {
                    final messageText = message.get('message');
                    final messageSender = message.get('sender');
                    final messageReceiver = message.get('receiver');
                    late final messageWidget;
                    if (((messageReceiver == ChatScreen.friendEmail) &&
                            (messageSender == loggedInUser.email)) ||
                        ((messageSender == ChatScreen.friendEmail) &&
                            (messageReceiver == loggedInUser.email))) {
                      if (messageSender == loggedInUser.email) {
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
                      } else if (messageSender != loggedInUser.email) {
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
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  textController.clear();
                  _firestore.collection('messages').add({
                    'message': message,
                    'sender': loggedInUser.email,
                    'receiver': ChatScreen.friendEmail
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
