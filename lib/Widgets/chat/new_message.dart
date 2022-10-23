import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  String chatId;

  NewMessage(this.chatId);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messages = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void sendMessage(String message) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final userName = await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();

    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .doc()
        .set({
      "text": message,
      "timeStamp": Timestamp.now(),
      "userId": _auth.currentUser!.uid,
      "userName": userName["username"]
    });

    /* FirebaseFirestore.instance.collection("chats/").add({
      "text": message,
      "timeStamp": Timestamp.now(),
      "userId": _auth.currentUser!.uid,
      "userName": userName["username"]
    }); */

    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messages,
              decoration: InputDecoration(hintText: "Send it."),
            ),
          ),
          IconButton(
              onPressed: () {
                print("ssss");
                print(widget.chatId);
                _messages.text.trim().isEmpty
                    ? null
                    : sendMessage(_messages.text);
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
