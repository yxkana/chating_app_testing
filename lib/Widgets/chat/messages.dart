import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat/")
            .orderBy("timeStamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: ((context, index) {
              String _message = snapshot.data!.docs[index]["text"];
              final _currentUser = _auth.currentUser!.uid;
              final Timestamp timestamp =
                  snapshot.data!.docs[index]["timeStamp"];
              final DateTime dateTime = timestamp.toDate();
              final dateString = DateFormat("K:mm:ss").format(dateTime);

              final userId = snapshot.data!.docs[index]["userId"];
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .snapshots(),
                builder: ((context, snapshot2) {
                  if (snapshot.data!.docs[index]["userId"] == _currentUser) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(dateString)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 5, right: 20, bottom: 10),
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 250),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(5)),
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      _message,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ))),
                          ),
                        )
                      ],
                      /* ext(snapshot.data!.docs[index]["text"]) */
                    );
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(dateString)),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: snapshot2.hasData
                                  ? NetworkImage(snapshot2.data!["userImgUrl"])
                                  : null,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 5, left: 10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(10)),
                                  color: Colors.grey[300]),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  snapshot.data!.docs[index]["text"],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    /* ext(snapshot.data!.docs[index]["text"]) */
                  );
                }),
              );
            }),
            itemCount: snapshot.data!.docs.length,
          );
        });
  }
}
