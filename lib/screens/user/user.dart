import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/icon_item.dart';
import 'package:zpevnik/screens/components/search_field.dart';
import 'package:zpevnik/screens/user/components/playlists_list.dart';
import 'package:zpevnik/screens/user/components/user_menu.dart';
import 'package:zpevnik/screens/user/favorites.dart';
import 'package:zpevnik/screens/user/settings.dart';
import 'package:zpevnik/theme.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late bool _showingArchived;

  @override
  void initState() {
    super.initState();

    _showingArchived = false;
  }

  @override
  Widget build(BuildContext context) {
    final playlistsProvider = context.watch<PlaylistsProvider>();

    return PlatformScaffold(
      body: Column(
        children: [
          _buildSearchField(context),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: SingleChildScrollView(
                child: Column(children: [
                  if (playlistsProvider.searchText.isEmpty)
                    IconItem(onPressed: _pushFavorites, title: 'Písně s hvězdičkou', icon: Icons.star),
                  PlaylistsList(
                    playlists: playlistsProvider.playlists,
                    isReorderable: playlistsProvider.searchText.isEmpty,
                  ),
                  if (playlistsProvider.archivedPlaylists.isNotEmpty)
                    IconItem(
                      onPressed: () => setState(() => _showingArchived = !_showingArchived),
                      title: 'Archiv',
                      icon: Icons.archive_outlined,
                      trailingIcon: _showingArchived ? Icons.arrow_upward : Icons.arrow_downward,
                    ),
                  if (_showingArchived) PlaylistsList(playlists: playlistsProvider.archivedPlaylists),
                ]),
              ),
            ),
          ),
          _buildOthersPanel(context),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final playlistsProvider = context.watch<PlaylistsProvider>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey(widget.key.toString() + '_search_field'),
        placeholder: 'Zadejte název seznamu písní',
        onSearch: (searchText) => playlistsProvider.searchText = searchText,
      ),
    );
  }

  Widget _buildOthersPanel(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(children: [
        Text('Ostatní', style: appTheme.bodyTextStyle),
        Spacer(),
        Highlightable(
          child: Icon(Icons.settings),
          onPressed: _pushSettings,
          padding: EdgeInsets.all(kDefaultPadding / 2),
        ),
        Highlightable(
          child: Icon(Icons.menu),
          onPressed: () => _showUserMenu(context),
          padding: EdgeInsets.all(kDefaultPadding / 2),
        ),
      ]),
    );
  }

  void _pushFavorites() => Navigator.of(context).push(platformRouteBuilder(
        context,
        FavoritesScreen(),
        types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist],
      ));

  void _pushSettings() => Navigator.of(context, rootNavigator: true).push(platformRouteBuilder(
        context,
        SettingsScreen(),
        types: [ProviderType.data],
      ));

  void _showUserMenu(BuildContext context) {
    return showPlatformBottomSheet(
      context: context,
      builder: (_) => MultiProvider(providers: [ProviderType.data.provider(context)], builder: (_, __) => UserMenu()),
      height: 300,
    );
  }
}
