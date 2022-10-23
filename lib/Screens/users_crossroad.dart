import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Routes/CustomRouteForPopUp.dart';
import '../Widgets/profiles/popUpWindow.dart';
import '../Widgets/profiles/popImageWindowWith.dart';

class ScrossRoadsScreen extends StatefulWidget {
  const ScrossRoadsScreen({super.key});

  @override
  State<ScrossRoadsScreen> createState() => _ScrossRoadsScreenState();
}

NetworkImage? _networkImage;

class _ScrossRoadsScreenState extends State<ScrossRoadsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Screen Ink",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 36,
                    fontFamily: "InterBold"),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: Firebase.initializeApp(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email",
                          isNotEqualTo:
                              FirebaseAuth.instance.currentUser!.email)
                      .get()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: ((context, index) {
                              String heroTag = index.toString() + "Profile";

                              return GestureDetector(
                                onTap: () async {
                                  await snapshot.hasData;

                                  if (snapshot.data!.docs[index]
                                      .data()
                                      .containsKey("userImgUrl")) {
                                    Navigator.of(context).push(HeroDialogRoute(
                                      builder: ((context) {
                                        return popUpProfile(
                                            snapshot.data!.docs[index]
                                                ["username"],
                                            NetworkImage(snapshot.data!
                                                .docs[index]["userImgUrl"]),
                                            heroTag,
                                            snapshot.data!.docs[index].reference
                                                .id);
                                      }),
                                    ));
                                  } else {
                                    Navigator.of(context).push(HeroDialogRoute(
                                      builder: ((context) {
                                        return popUpProfileWith(
                                            snapshot.data!.docs[index]
                                                ["username"],
                                            heroTag);
                                      }),
                                    ));
                                  }
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      snapshot.hasData
                                          ? Hero(
                                              tag: heroTag,
                                              child: CircleAvatar(
                                                  backgroundColor: snapshot
                                                          .data!.docs[index]
                                                          .data()
                                                          .containsKey(
                                                              "userImgUrl")
                                                      ? Colors.transparent
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                  backgroundImage: snapshot
                                                          .data!.docs[index]
                                                          .data()
                                                          .containsKey(
                                                              "userImgUrl")
                                                      ? NetworkImage(snapshot
                                                              .data!.docs[index]
                                                          ["userImgUrl"])
                                                      : null,
                                                  child: snapshot
                                                          .data!.docs[index]
                                                          .data()
                                                          .containsKey("userImgUrl")
                                                      ? null
                                                      : Icon(
                                                          Icons.person,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        )),
                                            )
                                          : CircularProgressIndicator(),
                                      Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(snapshot.data!.docs[index]
                                              ["username"]))
                                    ],
                                  ),
                                ),
                              );
                            })),
                      );
                    }
                    return Center(child: null);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
