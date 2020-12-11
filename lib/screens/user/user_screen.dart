import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/screens/components/playlist_row.dart';
import 'package:zpevnik/screens/user/components/user_menu.dart';
import 'package:zpevnik/screens/user/favorite_screen.dart';
import 'package:zpevnik/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with PlatformStateMixin {
  final _searchFieldFocusNode = FocusNode();

  bool _showingArchived;

  @override
  void initState() {
    super.initState();

    _showingArchived = false;

    PlaylistsProvider.shared.addListener(_update);
  }

  @override
  Widget iOSWidget(BuildContext context) => StatusBarWrapper(child: CupertinoPageScaffold(child: _body(context)));

  @override
  Widget androidWidget(BuildContext context) => StatusBarWrapper(child: Scaffold(body: _body(context)));

  Widget _body(BuildContext context) {
    final playlists = PlaylistsProvider.shared.playlists;
    final archivedPlaylists = PlaylistsProvider.shared.archivedPlaylists;

    return SafeArea(
      child: Column(
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: kDefaultPadding), child: _searchWidget(context)),
          Expanded(child: () {
            if (playlists.isEmpty && archivedPlaylists.isEmpty)
              return Center(
                child: GestureDetector(
                  onTap: () => PlaylistsProvider.shared.showPlaylistDialog(context, callback: () => setState(() => {})),
                  child: Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Text(
                      'Nemáte žádný playlist. Vytvořit si jej můžete v${unbreakableSpace}náhledu písně nebo kliknutím na${unbreakableSpace}tento text.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            return Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (PlaylistsProvider.shared.searchText.isEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                        child: Text(
                          'Seznamy písní',
                          style: AppTheme.of(context).bodyTextStyle.copyWith(color: red),
                        ),
                      ),
                    if (PlaylistsProvider.shared.searchText.isEmpty)
                      HighlightableRow(
                          onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => FavoriteScreen()),
                              ),
                          child: Row(
                            children: [
                              Container(padding: EdgeInsets.only(right: kDefaultPadding), child: Icon(Icons.star)),
                              Text('Písně s hvězdičkou', style: AppTheme.of(context).bodyTextStyle),
                            ],
                          )),
                    ReorderableList(
                      onReorder: _onReorder,
                      onReorderDone: _onReorderDone,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) => PlaylistRow(
                          playlist: playlists[index],
                          reorderable: true,
                          onSelect: () =>
                              setState(() => _showingArchived &= PlaylistsProvider.shared.archivedPlaylists.isNotEmpty),
                        ),
                      ),
                    ),
                    if (archivedPlaylists.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _showingArchived = !_showingArchived),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5 * kDefaultPadding,
                            vertical: kDefaultPadding,
                          ),
                          child: Row(children: [
                            Container(
                              padding: EdgeInsets.only(right: kDefaultPadding),
                              child: Icon(Icons.archive_outlined),
                            ),
                            Expanded(child: Text('Archiv', style: AppTheme.of(context).bodyTextStyle)),
                            // todo: add animation
                            Icon(_showingArchived ? Icons.arrow_upward : Icons.arrow_downward),
                          ]),
                        ),
                      ),
                    if (_showingArchived)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: archivedPlaylists.length,
                        itemBuilder: (context, index) => PlaylistRow(
                          playlist: archivedPlaylists[index],
                          reorderable: false,
                          onSelect: () =>
                              setState(() => _showingArchived &= PlaylistsProvider.shared.archivedPlaylists.isNotEmpty),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }()),
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Row(children: [
              Text('Ostatní', style: AppTheme.of(context).bodyTextStyle),
              Spacer(),
              GestureDetector(onTap: () => _showUserMenu(context), child: Icon(Icons.menu)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _searchWidget(BuildContext context) => SearchWidget(
        key: PageStorageKey('user_screen_search_widget'),
        placeholder: 'Zadejte název seznamu písní',
        focusNode: _searchFieldFocusNode,
        search: PlaylistsProvider.shared.search,
        prefix: HighlightableButton(
          icon: Icon(Icons.search),
          onPressed: () => FocusScope.of(context).requestFocus(_searchFieldFocusNode),
        ),
      );

  void _showUserMenu(BuildContext context) {
    FocusScope.of(context).unfocus();

    return showPlatformBottomSheet(
      context: context,
      child: UserMenuWidget(),
      height: 0.5 * MediaQuery.of(context).size.height,
    );
  }

  bool _onReorder(Key from, Key to) {
    int fromIndex = PlaylistsProvider.shared.allPlaylists.indexWhere((playlist) => playlist.key == from);
    int toIndex = PlaylistsProvider.shared.allPlaylists.indexWhere((playlist) => playlist.key == to);

    final playlist = PlaylistsProvider.shared.allPlaylists[fromIndex];
    setState(() {
      PlaylistsProvider.shared.allPlaylists.removeAt(fromIndex);
      PlaylistsProvider.shared.allPlaylists.insert(toIndex, playlist);
    });
    return true;
  }

  void _onReorderDone(_) {
    for (int i = 0; i < PlaylistsProvider.shared.allPlaylists.length; i++)
      PlaylistsProvider.shared.allPlaylists[i].orderValue = i;
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    PlaylistsProvider.shared.removeListener(_update);

    super.dispose();
  }
}
