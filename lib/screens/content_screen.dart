import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/home/home_screen.dart';
import 'package:zpevnik/screens/songbooks/songbooks_screen.dart';
import 'package:zpevnik/screens/user/user_screen.dart';

class ContentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with PlatformStateMixin {
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoTabScaffold(
        tabBuilder: (context, _) => CupertinoTabView(builder: (context) => _activeWidget),
        tabBar: CupertinoTabBar(
          backgroundColor: CupertinoColors.quaternarySystemFill,
          activeColor: _activeColor,
          items: _tabBarItems,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        body: _activeWidget,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: _activeColor,
          items: _tabBarItems,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );

  Widget get _activeWidget => _currentIndex == 0
      ? const HomeScreen(key: PageStorageKey('home_screen'))
      : (_currentIndex == 1
          ? const SongbooksScreen(key: PageStorageKey('songbooks_screen'))
          : const UserScreen(key: PageStorageKey('user_screen')));

  Color get _activeColor => _currentIndex == 0 ? blue : (_currentIndex == 1 ? green : red);

  List<BottomNavigationBarItem> get _tabBarItems => [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Vyhledávání',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.import_contacts),
          label: 'Zpěvníky',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Já',
          activeIcon: Icon(Icons.person),
        ),
      ];
}
