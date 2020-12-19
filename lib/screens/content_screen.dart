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

  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final songbooksNavigatorKey = GlobalKey<NavigatorState>();
  final userNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _activeColor = blue;
    _currentIndex = 0;
  }

  @override
  Widget iOSWidget(BuildContext context) => Consumer<FullScreenProvider>(
        builder: (context, provider, _) => provider.fullScreen
            ? CupertinoTabView(
                navigatorKey: _navigatorKey(_currentIndex), builder: (context) => _activeWidget(_currentIndex))
            : CupertinoTabScaffold(
                tabBuilder: (context, index) =>
                    CupertinoTabView(navigatorKey: _navigatorKey(index), builder: (context) => _activeWidget(index)),
                tabBar: CupertinoTabBar(
                  backgroundColor: CupertinoColors.quaternarySystemFill,
                  activeColor: _activeColor,
                  items: _tabBarItems,
                  onTap: _indexChanged,
                ),
              ),
      );

  @override
  Widget androidWidget(BuildContext context) {
    final fullScreenProvider = Provider.of<FullScreenProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _currentIndex != 0,
            child: CustomNavigator(child: const HomeScreen(key: PageStorageKey('home_screen'))),
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: CustomNavigator(child: const SongbooksScreen(key: PageStorageKey('songbooks_screen'))),
          ),
          Offstage(
            offstage: _currentIndex != 2,
            child: CustomNavigator(child: const UserScreen(key: PageStorageKey('user_screen'))),
          ),
        ],
      ),
      bottomNavigationBar: fullScreenProvider.fullScreen
          ? null
          : BottomNavigationBar(
              selectedItemColor: _activeColor,
              items: _tabBarItems,
              currentIndex: _currentIndex,
              onTap: _indexChanged,
            ),
    );
  }

  Widget _activeWidget(int index) => index == 0
      ? const HomeScreen(key: PageStorageKey('home_screen'))
      : (index == 1
          ? const SongbooksScreen(key: PageStorageKey('songbooks_screen'))
          : const UserScreen(key: PageStorageKey('user_screen')));

  GlobalKey<NavigatorState> _navigatorKey(int index) =>
      index == 0 ? homeNavigatorKey : (index == 1 ? songbooksNavigatorKey : userNavigatorKey);

  void _indexChanged(int index) => setState(() {
        _currentIndex = index;
        _activeColor = index == 0 ? blue : (index == 1 ? green : red);
      });

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
