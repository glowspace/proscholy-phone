import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom_navigator.dart';
import 'package:zpevnik/providers/full_screen_provider.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/home/home_screen.dart';
import 'package:zpevnik/screens/songbooks/songbooks_screen.dart';
import 'package:zpevnik/screens/user/user_screen.dart';

class ContentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with PlatformStateMixin {
  Color _activeColor;
  int _currentIndex;

  final _navigatorKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];
  final _screens = [
    const HomeScreen(key: PageStorageKey('home_screen')),
    const SongbooksScreen(key: PageStorageKey('songbooks_screen')),
    const UserScreen(key: PageStorageKey('user_screen')),
  ];

  @override
  void initState() {
    super.initState();

    _activeColor = blue;
    _currentIndex = 0;
  }

  @override
  Widget iOSWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, child) => provider.fullScreen
            ? child
            : CupertinoTabScaffold(
                tabBuilder: (context, index) =>
                    CupertinoTabView(navigatorKey: _navigatorKeys[index], builder: (context) => _screens[index]),
                tabBar: CupertinoTabBar(
                  backgroundColor: CupertinoColors.quaternarySystemFill,
                  activeColor: _activeColor,
                  items: _tabBarItems,
                  onTap: _indexChanged,
                ),
              ),
        child: CupertinoTabView(
          navigatorKey: _navigatorKeys[_currentIndex],
          builder: (context) => _screens[_currentIndex],
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, child) => WillPopScope(
          onWillPop: () async {
            // end fullscreen mode when going back, so navigation bars appear correctly
            provider.fullScreen = false;
            return !await _navigatorKeys[_currentIndex].currentState.maybePop();
          },
          child: Scaffold(
            body: child,
            bottomNavigationBar: provider.fullScreen
                ? null
                : BottomNavigationBar(
                    selectedItemColor: _activeColor,
                    items: _tabBarItems,
                    currentIndex: _currentIndex,
                    onTap: _indexChanged,
                  ),
          ),
        ),
        child: Stack(children: [_offstage(0), _offstage(1), _offstage(2)]),
      );

  Widget _offstage(int index) => Offstage(
        offstage: _currentIndex != index,
        child: CustomNavigator(navigatorKey: _navigatorKeys[index], child: _screens[index]),
      );

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

  void _indexChanged(int index) => setState(() {
        _currentIndex = index;
        _activeColor = index == 0 ? blue : (index == 1 ? green : red);
      });
}
