import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/screens/components/search_field.dart';
import 'package:zpevnik/screens/components/songbook_tile.dart';
import 'package:zpevnik/theme.dart';

class SongbooksGridView extends StatefulWidget {
  const SongbooksGridView({Key? key}) : super(key: key);

  @override
  State<SongbooksGridView> createState() => _SongbooksGridViewState();
}

class _SongbooksGridViewState extends State<SongbooksGridView> {
  final scrollController = ScrollController();
  final searchFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Column(children: [
        _buildSearchField(context),
        Expanded(
          child: Consumer<SongbooksProvider>(builder: (_, provider, __) {
            if (provider.songbooks.isEmpty) {
              return _buildSongbooksEmptyPlaceholder(context, provider);
            } else {
              return _buildListView(context, provider);
            }
          }),
        ),
      ]),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final provider = context.read<SongbooksProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey('${widget.key}_search_field'),
        placeholder: 'Zadejte název nebo zkratku zpěvníku',
        onSearchTextChanged: (searchText) {
          provider.searchText = searchText;

          if (provider.songbooks.isNotEmpty) {
            scrollController.animateTo(0.0, duration: kDefaultAnimationDuration, curve: Curves.easeInOut);
          }
        },
        focusNode: searchFieldFocusNode,
      ),
    );
  }

  Widget _buildListView(BuildContext context, SongbooksProvider provider) {
    return Scrollbar(
      controller: scrollController,
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 2,
        itemCount: provider.songbooks.length,
        itemBuilder: (_, index) => SongbookTile(songbook: provider.songbooks[index]),
      ),
    );
  }

  Widget _buildSongbooksEmptyPlaceholder(BuildContext context, SongbooksProvider provider) {
    final searchText = provider.searchText;

    final text = searchText.isNotEmpty
        ? 'Nebyl nalezen žádný výsledek pro${unbreakableSpace}hledaný výraz: "$searchText"'
        : 'Zatím nejsou k dispozici žádné zpěvníky';

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(child: Text(text, style: AppTheme.of(context).bodyTextStyle, textAlign: TextAlign.center)),
    );
  }
}
