import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './chat_screen.dart';
import '../main.dart';

class VerifeidEmailScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final Function(String, String, String) _functionAuth;

  VerifeidEmailScreen(
      this.email, this.password, this.username, this._functionAuth);

  @override
  State<VerifeidEmailScreen> createState() => _VerifeidEmailScreenState();
}

class _VerifeidEmailScreenState extends State<VerifeidEmailScreen> {
  bool isVerified = false;
  bool isEmailSend = false;
  static const maxSeconds = 90;
  int seconds = maxSeconds;
  Timer? timer;
  bool isEmailVerifeied = false;

  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();

  FocusNode? textfield1 = FocusNode();
  FocusNode? textfield2 = FocusNode();
  FocusNode? textfield3 = FocusNode();
  FocusNode? textfield4 = FocusNode();
  FocusNode? textfield5 = FocusNode();

  Duration duration = Duration();

  String _finalCode = "";
  String generatedCode = "";

  Future sendEmail(
      {required String email,
      required String username,
      required String code,
      required String subject}) async {
    final serviceId = "service_1fdbohi";
    final templateId = "template_rh1s0kd";
    final userId = "wpXYpZJQ2_RkTIEJC";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(url,
        headers: {
          "origin": "http://localhost",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "user_name": username,
            "user_email": email,
            "code": code,
            "email_subject": subject
          }
        }));
  }

  String generateCode() {
    generatedCode = "";
    for (var i = 0; i < 5; i++) {
      Random random = new Random();
      int randomNumber = random.nextInt(9);
      generatedCode = randomNumber.toString() + generatedCode;
    }

    return generatedCode;
  }

  @override
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void timerForVerification() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds <= 0) {
        timer.cancel();
        generatedCode = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Row(
                children: [
                  IconButton(
                      iconSize: 32,
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        timer!.cancel();
                        generatedCode = "";
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return MyApp();
                        })));
                      },
                      icon: Icon(Icons.arrow_back)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verification",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 48,
                      fontFamily: "InterBold"),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            isEmailSend
                ? Column(
                    children: [
                      Text(
                        "Enter code from email",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: "InterBold",
                            fontSize: 25),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Email: ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontFamily: "InterBold",
                                fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  child: TextField(
                                    onChanged: ((value) {
                                      if (value.isNotEmpty) {
                                        _finalCode = _finalCode + value;
                                        FocusScope.of(context)
                                            .requestFocus(textfield2);
                                      }
                                    }),
                                    controller: _textEditingController1,
                                    focusNode: textfield1,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: 1,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: "InterBold",
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _finalCode = _finalCode + value;
                                        FocusScope.of(context)
                                            .requestFocus(textfield3);
                                      }
                                      if (value.isEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(textfield1);
                                      }
                                    },
                                    controller: _textEditingController2,
                                    focusNode: textfield2,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: 1,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: "InterBold",
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _finalCode = _finalCode + value;
                                        FocusScope.of(context)
                                            .requestFocus(textfield4);
                                      }
                                      if (value.isEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(textfield2);
                                      }
                                    },
                                    controller: _textEditingController3,
                                    focusNode: textfield3,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: 1,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: "InterBold",
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _finalCode = _finalCode + value;
                                        FocusScope.of(context)
                                            .requestFocus(textfield5);
                                      }
                                      if (value.isEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(textfield3);
                                      }
                                    },
                                    controller: _textEditingController4,
                                    focusNode: textfield4,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: 1,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: "InterBold",
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _finalCode = _finalCode + value;
                                        print(_finalCode);
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                      if (value.isEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(textfield4);
                                      }
                                    },
                                    controller: _textEditingController5,
                                    focusNode: textfield5,
                                    keyboardType: TextInputType.number,
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    maxLines: 1,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: "InterBold",
                                        fontSize: 30),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      seconds == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Code expired.",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 18)),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      seconds = 90;
                                      timerForVerification();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        sendEmail(
                                            email: widget.email,
                                            username: widget.username,
                                            code: generateCode(),
                                            subject: "Email verification");
                                      },
                                      child: Text("send",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontSize: 20,
                                              fontFamily: "InterBold")),
                                    ),
                                  ),
                                ),
                                Text("again",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 18))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Code expire in",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 18),
                                ),
                                Container(
                                  height: 24,
                                  width: 32,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      seconds.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 20,
                                          fontFamily: "InterBold"),
                                    ),
                                  ),
                                ),
                                Text("seconds",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 18))
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 50),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if ((_textEditingController1.text +
                                  _textEditingController2.text +
                                  _textEditingController3.text +
                                  _textEditingController4.text +
                                  _textEditingController5.text) ==
                              generatedCode) {
                            try {
                              await widget._functionAuth(widget.email,
                                  widget.username, widget.password);
                            } finally {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyApp();
                              }), (route) => false);
                            }
                          } else if (seconds <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Your code expired !")),
                                )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: EdgeInsets.all(16),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                      "Your code is invalid ! Please check your email again."),
                                )));
                          }
                        },
                        label: Text("Verified"),
                        icon: Icon(Icons.vpn_key_rounded),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 50),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          setState(() {
                            timer!.cancel();
                            _textEditingController1.text = "";
                            _textEditingController2.text = "";
                            _textEditingController3.text = "";
                            _textEditingController4.text = "";
                            _textEditingController5.text = "";
                          });
                          seconds = 90;
                          timerForVerification();
                          generatedCode = "";
                          generateCode();
                          print(generatedCode);

                          /* await sendEmail(
                              email: widget.email,
                              username: widget.username,
                              code: generateCode(),
                              subject: "Code Varification"); */
                        },
                        label: Text("Send again"),
                        icon: Icon(Icons.email_outlined),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Send an email",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 35,
                              fontFamily: "InterBold",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            sendEmail(
                                email: widget.email,
                                username: widget.username,
                                code: generateCode(),
                                subject: "Verification Code");
                            setState(() {
                              timerForVerification();
                              isEmailSend = !isEmailSend;
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.email_outlined,
                                size: 55,
                                color: Theme.of(context).colorScheme.tertiary,
                              )),
                        ),
                      ),
                    ],
                  )
          ],
        )),
      ),
    );
  }
}
