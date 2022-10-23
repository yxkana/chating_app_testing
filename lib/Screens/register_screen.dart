import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Dependencies Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Screen
import './auth_verified_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;
  bool _showPasswordAgain = false;
  bool _authEmail = false;

  var nickNameText = TextEditingController();
  var eMailText = TextEditingController();
  var passwordText = TextEditingController();
  var repPassword = TextEditingController();

  final _auth = FirebaseAuth.instance;

  Future authRegister(String email, String userName, String password) async {
    try {
      var authResault = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authResault.user!.uid)
          .set({"username": userName, "email": email});
    } on PlatformException catch (err) {
      var message = "Something went wrong";
      if (err != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 33,
                ))
          ],
        ),
        Center(
            child: Text(
          "Screen Ink",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 48,
              fontFamily: "InterBold"),
        )),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.15,
        ),
        Padding(
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.33, bottom: 15),
          child: Text(
            "Register",
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
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: TextFormField(
                          controller: nickNameText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "No Username";
                            } else if (value.length >= 10) {
                              return "Too long max 10 characters";
                            } else if (value.length < 3) {
                              return "Too short min. 3 characters";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
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
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.3),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 20),
                              hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              hintText: "Nickname",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(18))))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: TextFormField(
                          controller: eMailText,
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
                                  color: Theme.of(context).colorScheme.primary),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(18))))),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: TextFormField(
                          controller: passwordText,
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
                                  color: Theme.of(context).colorScheme.primary),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(18)))),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(18)),
                      child: TextFormField(
                          validator: (value) {
                            if (value != passwordText.text) {
                              return "Password dont match!";
                            } else {
                              return null;
                            }
                          },
                          obscureText: !_showPasswordAgain,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 10),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPasswordAgain
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.6),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPasswordAgain = !_showPasswordAgain;
                                  });
                                },
                              ),
                              hintText: "Repeat Password",
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
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(18)))),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width * 1,
                              MediaQuery.of(context).size.height * 0.065),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      onPressed: () async {
                        bool _isValid = _formKey.currentState!.validate();
                        if (_isValid == true) {
                          _formKey.currentState?.save();
                          setState(() {
                            _authEmail = true;
                          });
                          if (_authEmail == true) {
                            print("ddddddddddd");
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return VerifeidEmailScreen(
                                    eMailText.text,
                                    passwordText.text,
                                    nickNameText.text,
                                    authRegister);
                              },
                            ));
                            
                            /* await authRegister(eMailText.text,
                                nickNameText.text, passwordText.text); */
                          }
                        }
                      },
                      child: Container(
                        child: Text(
                          "Register",
                          style:
                              TextStyle(fontSize: 18, fontFamily: "InterBold"),
                        ),
                      )),
                ),
              ],
            ))
      ]),
    );
  }
}
