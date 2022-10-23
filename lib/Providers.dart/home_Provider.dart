import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeProvider extends ChangeNotifier {
  int currentScreen;

  HomeProvider({this.currentScreen = 0});

  

  void changeCurrentsScreen(int newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
