import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:new_app/Providers.dart/home_Provider.dart';
import 'package:provider/provider.dart';

class popUpProfile extends StatefulWidget {
  final String text;
  final NetworkImage networkImage;
  final String heroTag;
  final String oponentId;

  popUpProfile(this.text, this.networkImage, this.heroTag, this.oponentId);

  @override
  State<popUpProfile> createState() => _popUpProfileState();
}

class _popUpProfileState extends State<popUpProfile> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return GestureDetector(
      onTap: (() {
        Navigator.pop(context);
      }),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {},
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).backgroundColor,
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 10),
                        child: Hero(
                          tag: widget.heroTag,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: widget.networkImage,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Text(
                            widget.text,
                            style: TextStyle(fontSize: 40),
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            /* final userName = await FirebaseFirestore.instance
                                .collection("users")
                                .doc(_auth.currentUser!.uid)
                                .get(); */

                            DocumentReference chatId = await FirebaseFirestore
                                .instance
                                .collection("chats")
                                .doc();

                            var list = [chatId.id];

                            await chatId
                                .set({
                                  "recentSender": "",
                                  "recentMessage": "",
                                  "users": [
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.oponentId
                                  ]
                                })
                                .then((value) => {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "chatsId": FieldValue.arrayUnion(list),
                                      })
                                    })
                                .then((value) => FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.oponentId)
                                        .update({
                                      "chatsId": FieldValue.arrayUnion(list),
                                    }));

                            /* Navigator.of(context).pop();

                            Provider.of<HomeProvider>(context, listen: false)
                                .changeCurrentsScreen(1); */
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.tertiary,
                            elevation: 2,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child:
                                          Icon(Icons.messenger_outline_sharp)),
                                  Text("Send message")
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.tertiary,
                          elevation: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Icon(Icons.person_add_alt)),
                                Text("Add to friends list")
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
