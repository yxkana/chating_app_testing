import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Widgets/profiles/main_profile.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({super.key});

  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 160),
                child: Text(
                  "Wall",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 36,
                      fontFamily: "InterBold"),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 10), child: MainProfile())
          ],
        ),
        Expanded(
            child: Center(
          child: Text("Wall is building"),
        ))
      ],
    );
  }
}
