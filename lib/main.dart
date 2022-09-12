import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Screens
import './Screens/chat_screen.dart';
import 'Screens/auth_screen.dart';

//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(const MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SocAppLearing',
        theme: ThemeData(
            fontFamily: "InterRegular",
            backgroundColor: Color.fromARGB(255, 253, 255, 238),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Color.fromARGB(255, 222, 160, 87),
                secondary: Color.fromARGB(255, 54, 54, 32),
                tertiary: Color.fromARGB(255, 246, 147, 61))),
        home: const AuthScreen());
  }
}
