import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.32,
              ),
              Center(
                child: Text(
                  "Screen Ink",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 50,
                      fontFamily: "InterBold"),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ));
  }
}
