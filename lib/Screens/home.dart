import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:new_app/Providers.dart/home_Provider.dart';
import 'package:provider/provider.dart';

//Screens
import './profile_page.dart';
import 'people.dart';
import './chat_screen.dart';
import './wallScreen.dart';
import './messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<Map<String, Object>> _pages = [
  {"page": WallScreen(), "title": "Wall Screen"},
  {"page": MessagesScreen(), "title": "Message Screen"},
  {"page": ScrossRoadsScreen(), "title": "Favorite Meals"},
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _homeProvider = Provider.of<HomeProvider>(context);

    int _currentAppBarIndex = _homeProvider.currentScreen;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentAppBarIndex,
          onTap: (value) {
            setState(() {
              _homeProvider.currentScreen = value;
              print(_currentAppBarIndex);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: _currentAppBarIndex == 0
                    ? const Icon(Icons.view_compact_rounded)
                    : const Icon(Icons.view_compact_outlined),
                label: "Wall"),
            BottomNavigationBarItem(
                icon: _currentAppBarIndex == 1
                    ? const Icon(Icons.message_rounded)
                    : const Icon(Icons.message_outlined),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: _currentAppBarIndex == 2
                    ? const Icon(Icons.people_alt_rounded)
                    : const Icon(Icons.people_alt_outlined),
                label: "Peaople")
          ]),
      body: _pages[_currentAppBarIndex]["page"] as Widget,
    );
  }
}
