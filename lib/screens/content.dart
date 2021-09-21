import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/components/invisible_tab_bar.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/loading.dart';
import 'package:zpevnik/screens/songbooks.dart';
import 'package:zpevnik/screens/user/user.dart';
import 'package:zpevnik/screens/utils/updateable.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with PlatformMixin, Updateable {
  final dataProvider = DataProvider();
  final fullScreenProvider = FullScreenProvider();

  late int _currentIndex;
  late Future<void> _updateFuture;

  // needed for CupertinoTabView, so it keeps state correctly
  late List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _updateFuture = dataProvider.update();

    _navigatorKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: _activeColors[_currentIndex],
        currentIndex: _currentIndex,
        items: _tabBarItems,
        onTap: _indexChanged,
      ),
      body: Stack(children: [_offstage(0), _offstage(1), _offstage(2)]),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    final tabBar = fullScreenProvider.isFullScreen
        ? InvisibleCupertinoTabBar()
        : CupertinoTabBar(
            activeColor: _activeColors[_currentIndex],
            backgroundColor: CupertinoColors.quaternarySystemFill,
            items: _tabBarItems,
            onTap: _indexChanged,
          );

    return CupertinoTabScaffold(
      tabBar: tabBar,
      tabBuilder: (context, index) => CupertinoTabView(
        navigatorKey: _navigatorKeys[index],
        builder: (context) => _screens[index],
      ),
    );
  }

  @override
  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) {
    return FutureBuilder(
      future: _updateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return LoadingScreen();

        if (snapshot.hasError)
          return PlatformScaffold(
            body: Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Text(snapshot.error.toString()),
            ),
          );

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: dataProvider),
            ChangeNotifierProvider.value(value: fullScreenProvider),
            ChangeNotifierProvider(create: (_) => PlaylistsProvider(dataProvider.playlists)),
          ],
          builder: (context, _) => builder(context),
        );
      },
    );
  }

  Widget _offstage(int index) => Offstage(offstage: _currentIndex != index, child: _screens[index]);

  List<Widget> get _screens => [const HomeScreen(), const SongbooksScreen(), const UserScreen()];

  List<BottomNavigationBarItem> get _tabBarItems {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Vyhledávání'),
      BottomNavigationBarItem(icon: Icon(Icons.import_contacts), label: 'Zpěvníky'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Já'),
    ];
  }

  List<Color> get _activeColors => [blue, green, red];

  void _indexChanged(int index) {
    // TODO: pop and reset state

    setState(() => _currentIndex = index);
  }

  @override
  List<Listenable> get listenables => [fullScreenProvider];
}
