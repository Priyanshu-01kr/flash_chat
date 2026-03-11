import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  final messageTextFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  late String typedMessage;
  final _store = FirebaseFirestore.instance.collection('texts');

  //Note:
  // QuerySnapshot snapshot = await FirebaseFirestore.instance
  //     .collection('users')
  //     .get();
  //
  // List<QueryDocumentSnapshot> docs = snapshot.docs;
  // for (var doc in docs) {
  // print(doc.id);
  // print(doc.data());
  // }

  void getMessages() async {
    final messages = await _store.get();
    for (var message in messages.docs) {
      //its.data() method
      //why not .docs??
      print(message.data());
    }
  }

  void getMessageStream() async {
    await for (var snapshot in _store.snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //where is that back button coming from?
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
              // getMessages();
              // getMessageStream();
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
              stream: _store.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data?.docs.reversed;

                List<MessageBubble> messageWidgets = [];

                for (var message in messages!) {
                  final messageText = message.data()['message'];
                  final messageSender = message.data()['sender'];
                  final currentUser = loggedInUser?.email;
                  final messageWidget = MessageBubble(
                    sender: messageSender,
                    message: messageText,
                    isMe: currentUser == messageSender,
                  );
                  getMessageStream();
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextFieldController,
                      onChanged: (value) {
                        typedMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextFieldController.clear();
                      _store.add({
                        'message': typedMessage,
                        'sender': loggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  const MessageBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    Color bubbleColor;
    BorderRadius borderRadius;
    CrossAxisAlignment crossAxisAlignment;
    if (isMe) {
      bubbleColor = Colors.lightBlueAccent;
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );
      crossAxisAlignment = CrossAxisAlignment.end;
    } else {
      bubbleColor = Colors.blueGrey.shade500;
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );
      crossAxisAlignment = CrossAxisAlignment.start;
    }
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment, // may use ternary operator
        children: [
          Text(sender, style: TextStyle(fontSize: 12.0, color: Colors.black54)),
          Material(
            elevation: 5.0,
            borderRadius: borderRadius,
            color: bubbleColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
