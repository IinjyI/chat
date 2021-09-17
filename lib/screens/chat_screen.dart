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
  static String user = '';
  void getFriends() async {
    final data =
        await _firestore.collection('users').doc('yK2sZENWGdfOuXaTQ8Dj').get();
    setState(() {
      user = data['user'].toString();
    });
  }

  late String message;
  final textController = TextEditingController();
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: ChatLogo(chatFontSize: 0),
              onTap: () {},
            ),
            Text(
              user,
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
                    final messageWidget = Container(
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
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  textController.clear();
                  _firestore
                      .collection('messages')
                      .add({'message': message, 'sender': loggedInUser.email});
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
