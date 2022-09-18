import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messages = TextEditingController();

  void sendMessage(String message) {
    FocusManager.instance.primaryFocus?.unfocus();
    FirebaseFirestore.instance
        .collection("chat")
        .add({"text": message, "timeStamp": Timestamp.now()});
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
