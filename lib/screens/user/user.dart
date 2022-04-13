import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
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
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool showingArchived = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Column(
        children: [
          _buildSearchField(context),
          Expanded(child: _buildContent(context)),
          const SizedBox(height: kDefaultPadding / 2),
          _buildOthersPanel(context),
          const SizedBox(height: kDefaultPadding / 2),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final playlistsProvider = context.read<PlaylistsProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey('${widget.key}_search_field'),
        placeholder: 'Zadejte název seznamu písní',
        onSearchTextChanged: (searchText) => playlistsProvider.searchText = searchText,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: Consumer<PlaylistsProvider>(
          builder: (_, provider, __) => StatefulBuilder(
            builder: (_, setState) => Column(children: [
              if (provider.searchText.isEmpty)
                IconItem(onPressed: () => _pushFavorites(context), title: 'Písně s hvězdičkou', icon: Icons.star),
              PlaylistsList(
                playlists: provider.playlists,
                isReorderable: provider.searchText.isEmpty,
              ),
              if (provider.archivedPlaylists.isNotEmpty)
                IconItem(
                  onPressed: () => setState(() => showingArchived = !showingArchived),
                  title: 'Archiv',
                  icon: Icons.archive_outlined,
                  trailingIcon: showingArchived ? Icons.arrow_upward : Icons.arrow_downward,
                ),
              if (showingArchived) PlaylistsList(playlists: provider.archivedPlaylists),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildOthersPanel(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: kDefaultPadding, right: 0.75 * kDefaultPadding),
      child: Row(children: [
        Expanded(child: Text('Ostatní', style: appTheme.bodyTextStyle)),
        Highlightable(
          child: const Icon(Icons.settings),
          onPressed: () => _pushSettings(context),
          padding: const EdgeInsets.all(kDefaultPadding / 4),
        ),
        Highlightable(
          child: const Icon(Icons.menu),
          onPressed: () => _showUserMenu(context),
          padding: const EdgeInsets.all(kDefaultPadding / 4),
        ),
      ]),
    );
  }

  void _pushFavorites(BuildContext context) {
    Navigator.of(context).push(
      platformRouteBuilder(
        context,
        const FavoritesScreen(),
        types: [ProviderType.data, ProviderType.fullScreen, ProviderType.playlist],
      ),
    );
  }

  void _pushSettings(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      platformRouteBuilder(
        context,
        const SettingsScreen(),
        types: [ProviderType.data],
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showPlatformBottomSheet(
      context: context,
      builder: (_) => MultiProvider(providers: [ProviderType.data.provider(context)], child: const UserMenu()),
      height: 300,
    );
  }
}
