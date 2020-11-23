import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom_icon_icons.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/playlists_provider.dart';
import 'package:zpevnik/screens/components/custom_icon_button.dart';
import 'package:zpevnik/screens/components/higlightable_row.dart';
import 'package:zpevnik/screens/components/playlist_row.dart';
import 'package:zpevnik/screens/components/popup_menu.dart';
import 'package:zpevnik/screens/components/reorderable_row.dart';
import 'package:zpevnik/screens/user/components/user_menu.dart';
import 'package:zpevnik/screens/user/favorite_screen.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with PlatformStateMixin {
  final navBarKey = GlobalKey();
  final searchFieldFocusNode = FocusNode();

  ValueNotifier<bool> _showingMenu;
  ValueNotifier<GlobalKey> _showingMenuKey;
  Playlist _activePlaylist;

  bool _showingArchived;

  @override
  void initState() {
    super.initState();

    _showingArchived = false;
    _showingMenu = ValueNotifier(false);
    _showingMenuKey = ValueNotifier(null)
      ..addListener(() {
        _showingMenu.value = _showingMenuKey.value != null;
        if (_showingMenu.value) setState(() => {});
      });
    _activePlaylist = null;
  }

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: _searchWidget(context), key: navBarKey),
        child: _body(context),
      );

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
        appBar: AppBar(title: _searchWidget(context), key: navBarKey),
        body: _body(context),
      );

  Widget _body(BuildContext context) {
    final playlists = PlaylistsProvider.shared.playlists;
    final archivedPlaylists = PlaylistsProvider.shared.archivedPlaylists;

    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onPanDown: _showingMenuKey.value == null ? null : (_) => _showingMenuKey.value = null,
            behavior: HitTestBehavior.translucent,
            child: Column(
              children: [
                Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        HighlightableRow(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => FavoriteScreen()),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                          icon: Icons.star,
                          title: 'Písně s hvězdičkou',
                        ),
                        ReorderableList(
                          onReorder: (Key from, Key to) {
                            int fromIndex =
                                PlaylistsProvider.shared.allPlaylists.indexWhere((playlist) => playlist.key == from);
                            int toIndex =
                                PlaylistsProvider.shared.allPlaylists.indexWhere((playlist) => playlist.key == to);

                            final playlist = PlaylistsProvider.shared.allPlaylists[fromIndex];
                            setState(() {
                              PlaylistsProvider.shared.allPlaylists.removeAt(fromIndex);
                              PlaylistsProvider.shared.allPlaylists.insert(toIndex, playlist);
                            });
                            return true;
                          },
                          onReorderDone: (_) {
                            for (int i = 0; i < PlaylistsProvider.shared.allPlaylists.length; i++)
                              PlaylistsProvider.shared.allPlaylists[i].orderValue = i;
                          },
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: playlists.length,
                            itemBuilder: (context, index) => ReorderableRow(
                              key: Key('${playlists[index].id}'),
                              child: PlaylistRow(
                                playlist: playlists[index],
                                select: (playlist) => _activePlaylist = playlist,
                                showingMenuKey: _showingMenuKey,
                              ),
                            ),
                          ),
                        ),
                        if (archivedPlaylists.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _showingArchived = !_showingArchived),
                            child: Container(
                              padding: EdgeInsets.all(kDefaultPadding / 2),
                              child: Row(children: [
                                Container(
                                  padding: EdgeInsets.only(right: kDefaultPadding / 2),
                                  child: Icon(Icons.archive_outlined),
                                ),
                                Expanded(child: Text('Archiv')),
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
                              select: (playlist) => _activePlaylist = playlist,
                              showingMenuKey: _showingMenuKey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(kDefaultPadding / 2),
                  child: Row(children: [
                    Text('Ostatní'),
                    Spacer(),
                    GestureDetector(onTap: () => _showUserMenu(context), child: Icon(Icons.menu)),
                  ]),
                ),
              ],
            ),
          ),
          if (playlists.isEmpty && archivedPlaylists.isEmpty)
            Center(
              child: GestureDetector(
                onTap: () => PlaylistsProvider.shared.showPlaylistDialog(context, callback: () => setState(() => {})),
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding / 2),
                  child: Text(
                    'Nemáte žádný playlist. Vytvořit si jej můžete v${unbreakableSpace}náhledu písně nebo kliknutím na${unbreakableSpace}tento text.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          Positioned(
            right: kDefaultPadding,
            top: _top,
            child: _popupWidget,
          )
        ],
      ),
    );
  }

  double get _top {
    if (_showingMenuKey.value == null) return 0;

    RenderBox box = _showingMenuKey.value.currentContext.findRenderObject();
    final position = box.localToGlobal(Offset.zero);

    RenderBox navBarBox = _showingMenuKey.value.currentContext.findRenderObject();

    return position.dy - navBarBox.size.height - 2 * kDefaultPadding - box.size.height;
  }

  Widget get _popupWidget => _activePlaylist == null
      ? Container()
      : PopupMenu(
          showing: _showingMenu,
          border: Border.all(color: AppTheme.shared.borderColor(context)),
          animateHide: false, // todo: animate hide, it looks really bad now
          children: [
            HighlightableRow(
              title: 'Přejmenovat',
              icon: Icons.drive_file_rename_outline,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              onPressed: () => _showRenameDialog(context),
            ),
            if (!_activePlaylist.isArchived)
              HighlightableRow(
                title: 'Duplikovat',
                icon: CustomIcon.content_duplicate,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                onPressed: () {
                  setState(() => PlaylistsProvider.shared.duplicate(_activePlaylist));
                  _showingMenuKey.value = null;
                },
              ),
            HighlightableRow(
              title: _activePlaylist.isArchived ? 'Zrušit archivaci' : 'Archivovat',
              icon: Icons.archive,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              onPressed: () {
                setState(() => _activePlaylist.isArchived = !_activePlaylist.isArchived);
                _showingMenuKey.value = null;
              },
            ),
            if (_activePlaylist.isArchived)
              HighlightableRow(
                title: 'Odstranit',
                icon: Icons.delete,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                onPressed: () {
                  setState(() => PlaylistsProvider.shared.remove(_activePlaylist));
                  _showingArchived &= PlaylistsProvider.shared.archivedPlaylists.isNotEmpty;
                  _showingMenuKey.value = null;
                },
              ),
          ],
        );

  Widget _searchWidget(BuildContext context) => SearchWidget(
        key: PageStorageKey('user_screen_search_widget'),
        placeholder: 'Zadejte název seznamu písní',
        focusNode: searchFieldFocusNode,
        leading: CustomIconButton(
          onPressed: () => FocusScope.of(context).requestFocus(searchFieldFocusNode),
          icon: Icon(Icons.search, color: AppTheme.shared.searchFieldIconColor(context)),
        ),
      );

  void _showUserMenu(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) => SizedBox(
          height: 0.5 * MediaQuery.of(context).size.height,
          child: UserMenuWidget(),
        ),
      );

  void _showRenameDialog(BuildContext context) {
    final textFieldController = TextEditingController()..text = _activePlaylist.name;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Přejmenovat playlist'),
        content: Container(
          child: TextField(
            decoration: InputDecoration(border: InputBorder.none, hintText: 'Název'),
            controller: textFieldController,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Zrušit', style: AppThemeNew.of(context).bodyTextStyle.copyWith(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _showingMenuKey.value = null;
            },
          ),
          // fixme: don't know better way to do it now, but there must be
          ChangeNotifierProvider.value(
            value: textFieldController,
            child: Consumer<TextEditingController>(
              builder: (context, controller, _) => TextButton(
                child: Text('Přejmenovat'),
                onPressed: controller.text.isEmpty
                    ? null
                    : () {
                        setState(() => _activePlaylist.name = controller.text);
                        Navigator.of(context).pop();
                        _showingMenuKey.value = null;
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
