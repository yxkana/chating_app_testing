import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_app/Providers.dart/home_Provider.dart';
import 'package:provider/provider.dart';

//Screens
import './Screens/chat_screen.dart';
import 'Screens/auth_screen.dart';
import './Screens/loading_screen.dart';
import './Screens/auth_verified_email_screen.dart';
import './Screens/home.dart';

//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic("chat");
  FirebaseMessaging.instance.setAutoInitEnabled(true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.instance.subscribeToTopic("chat");
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.data);
    print("-------------------");
    print("Got message");
    print("Message data: ${message.data}");
    if (message.notification != null) {
      print("notficic. message");
    }
  });

  FirebaseMessaging.onMessageOpenedApp;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => HomeProvider()))
      ],
      child: MaterialApp(
          title: 'SocAppLearing',
          theme: ThemeData(
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Color.fromARGB(255, 54, 54, 32)),
              fontFamily: "InterRegular",
              backgroundColor: Color.fromARGB(255, 253, 255, 238),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Color.fromARGB(255, 222, 160, 87),
                secondary: Color.fromARGB(255, 54, 54, 32),
                tertiary: Color.fromARGB(255, 246, 147, 61),
              ),
              buttonTheme: ButtonTheme.of(context)
                  .copyWith(buttonColor: Color.fromARGB(255, 246, 147, 61))),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              }

              if (snapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            }),
          )),
    );
  }
}
