import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "ChatRoom",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something is wrong with database"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chats/W7rn5ikTq9xjaoLHdaGl/mesagges")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final dokuments = snapshot.data!.docs;
                    return ListView.builder(
                      itemBuilder: ((context, index) {
                        return ClipRRect(
                            child: Container(
                          child: Text(dokuments[index]["text"]),
                        ));
                      }),
                      itemCount: dokuments.length,
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Text("Something is wrong"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final idMes = Uuid();
          final id = idMes.v4();
          FirebaseFirestore.instance
              .collection("chats/W7rn5ikTq9xjaoLHdaGl/mesagges")
              .add({"text": id});
        },
      ),
    );
  }
}
