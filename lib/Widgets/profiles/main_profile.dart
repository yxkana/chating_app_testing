import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Screens/profile_page.dart';

class MainProfile extends StatelessWidget {
  const MainProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry> popUpmenuList = [
      PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Text("Profile")
            ],
          )),
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
          )),
    ];
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return PopupMenuButton(
              child: CircleAvatar(
                  radius: 17,
                  backgroundImage:
                      NetworkImage(snapshot.data!.get("userImgUrl"))),
              onSelected: ((value) {
                if (value == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return MyProfile();
                  })));
                }
              }),
              itemBuilder: ((context) {
                return popUpmenuList;
              }));
        }
        return CircleAvatar(
          backgroundColor: Colors.white,
        );
      }),
    );
  }
}
