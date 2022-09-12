import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.46, bottom: 30),
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Container(
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18)),
                child: TextField(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        hintText: "Email",
                        border: InputBorder.none))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18)),
                child: TextField(
                    obscureText: !_showPassword,
                    textAlignVertical: TextAlignVertical.top,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 10),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        border: InputBorder.none))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width * 1,
                        MediaQuery.of(context).size.height * 0.065),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Theme.of(context).colorScheme.tertiary),
                onPressed: () {},
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
                    onTap: () {},
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
