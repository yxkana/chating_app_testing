import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Screens/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Messages",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 36,
                      fontFamily: "InterBold"),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 300,
                width: double.infinity,
                child: FutureBuilder(
                  future: Firebase.initializeApp(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshotUser) {
                        if (snapshotUser.hasData) {
                          List<dynamic> listLenght =
                              snapshotUser.data!["chatsId"];
                          if (listLenght.length == 0) {
                            return Center(
                              child: Text("No one to talk to"),
                            );
                          }

                          return ListView.builder(
                              itemCount: listLenght.length,
                              itemBuilder: ((context, index) {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("chats")
                                      .doc(listLenght[index])
                                      .snapshots(),
                                  builder: (context, snapshotChats) {
                                    if (snapshotChats.hasData) {
                                      String chatRoomId =
                                          snapshotChats.data!.id;

                                      List<dynamic> userId =
                                          snapshotChats.data!.get("users");
                                      DocumentReference userInfo =
                                          FirebaseFirestore
                                              .instance
                                              .collection("users")
                                              .doc(userId.first ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? userId.last
                                                  : userId.first);
                                      return InkWell(
                                        onTap: () {
                                          print(chatRoomId);
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return ChatScreen(chatRoomId);
                                          })));
                                        },
                                        child: FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(userId.first ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? userId.last
                                                  : userId.first)
                                              .get(),
                                          builder: (context, snapshotReciver) {
                                            if (snapshotReciver.hasData) {
                                              return ListTile(
                                                title: Text(snapshotReciver
                                                    .data!["username"]),
                                                leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            snapshotReciver
                                                                    .data![
                                                                "userImgUrl"])),
                                              );
                                            }
                                            return Container();
                                          },
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                );
                              }));
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ));
  }
}
