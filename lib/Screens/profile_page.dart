import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

File? _profileImg;
bool isPicture = false;

class _MyProfileState extends State<MyProfile> {
  Future addPicture() async {
    var img = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _profileImg = File(img!.path);
    });

    final ref = FirebaseStorage.instance
        .ref()
        .child("usersProfilePicture")
        .child("${FirebaseAuth.instance.currentUser!.uid}.jpg");

    if (_profileImg != null) {
      await ref.putFile(_profileImg!).whenComplete(() async {
        final url = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"userImgUrl": url});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              child: Column(children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 10),
                      child: IconButton(
                          iconSize: 30,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: ((context) {
                          return Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(1)),
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await addPicture();
                                      },
                                      child: Container(
                                        height: 80,
                                        child: Column(
                                          children: const [
                                            Icon(Icons.camera_alt),
                                            Text("Add photo")
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 80,
                                    ),
                                    Container(
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Icon(Icons.photo),
                                          Text("Galllery")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }));
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    backgroundImage:
                        snapshot.data!.data()!.containsKey("userImgUrl")
                            ? NetworkImage(snapshot.data!.get("userImgUrl"))
                            : null,
                    child: snapshot.data!.data()!.containsKey("userImgUrl")
                        ? null
                        : Icon(
                            Icons.person_add,
                            size: 45,
                            color: Theme.of(context).backgroundColor,
                          ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                snapshot.hasData
                    ? Text(
                        snapshot.data!.get("username"),
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "InterBold",
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : Text(""),
              ]),
            );
          },
        ));
  }
}
