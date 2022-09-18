import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/chat/messages.dart';
import '../Widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry> popUpmenuList = [
      PopupMenuItem(
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Logout")
                ]),
          ))
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: ((context) {
            return popUpmenuList;
          }))
        ],
        title: Text(
          "ChatRoom",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something is wrong with database"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: Column(
                    children: [Expanded(child: Messages())],
                  ),
                );
              } else {
                return Center(
                  child: Text("Something is wrong"),
                );
              }
            },
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: NewMessage())
      ]),
    );
  }
}
