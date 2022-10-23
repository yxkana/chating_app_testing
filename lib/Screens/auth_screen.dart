import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import './register_screen.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import './auth_verified_email_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  var _emailText = TextEditingController();
  var _passwordText = TextEditingController();
  var rng = 0;
  int count = 0;
  final _auth = FirebaseAuth.instance;

  Future authLogin(String email, String password) async {
    try {
      setState(() {
        _auth.signInWithEmailAndPassword(email: email, password: password);
      });
    } on PlatformException catch (err) {
      var message = "Something went wrong";
      if (err != null) {
        message = err.message!;
      }
      Scaffold.of(context).showBottomSheet((context) => SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.15),
            child: Center(
              child: Text(
                "Screen Ink",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 48,
                    fontFamily: "InterBold"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.46, bottom: 22),
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 38,
                  fontFamily: "InterBold",
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: TextFormField(
                            controller: _emailText,
                            validator: (value) {
                              bool isEmailValid = RegExp(
                                      (r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))
                                  .hasMatch(value!);
                              if (!value.contains("@")) {
                                return "Invalid email";
                              } else if (isEmailValid == false) {
                                return "Invalid email";
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.3),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(18)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(18)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(18)),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(18))))),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(18)),
                        child: TextFormField(
                            controller: _passwordText,
                            validator: (value) {
                              if (value!.length < 4) {
                                return "To short min. 4 characters";
                              } else {
                                return null;
                              }
                            },
                            obscureText: !_showPassword,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 10),
                                suffixIconColor:
                                    Theme.of(context).colorScheme.secondary,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.remove_red_eye,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.3),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(18)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(18)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(18)),
                                hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(18)))),
                      )),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 1,
                        MediaQuery.of(context).size.height * 0.065),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Theme.of(context).colorScheme.tertiary),
                onPressed: () {
                  bool _isValid = _formKey.currentState!.validate();
                  if (_isValid == true) {
                    _formKey.currentState?.save();

                    authLogin(_emailText.text, _passwordText.text);
                  } else {
                    return null;
                  }
                },
                child: Container(
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No account? Register",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return RegisterScreen();
                      })));
                    },
                    child: Text(
                      "Here",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
