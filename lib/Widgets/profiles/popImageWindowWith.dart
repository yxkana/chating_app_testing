import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class popUpProfileWith extends StatelessWidget {
  final String text;
  final String heroTag;

  popUpProfileWith(this.text, this.heroTag);

  @override
  Widget build(BuildContext context) {
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
                        padding: EdgeInsets.all(50),
                        child: Hero(
                          tag: heroTag,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            radius: 50,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 40),
                          ))
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
