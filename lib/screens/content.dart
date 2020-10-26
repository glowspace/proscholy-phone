import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/songbooks.dart';
import 'package:zpevnik/screens/user.dart';

class ContentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<ContentWidget> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS)
      return _iosWidget(context);
    else if (Platform.isAndroid) return _androidWidget(context);

    return Container();
  }

  Widget _iosWidget(BuildContext context) => CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: _tabBarItems(context)),
        tabBuilder: (BuildContext context, int index) => CupertinoPageScaffold(
          child: _activeWidget(context, index),
        ),
      );

  Widget _androidWidget(BuildContext context) => Scaffold(
        body: _activeWidget(context, _currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: _tabBarItems(context),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      );

  Widget _activeWidget(BuildContext context, int index) {
    switch (index) {
      case 0:
        return HomeWidget();
      case 1:
        return SongbooksWidget();
      case 2:
        return UserWidget();
      default:
        return Container();
    }
  }

  List<BottomNavigationBarItem> _tabBarItems(BuildContext context) => [
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
