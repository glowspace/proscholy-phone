import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/platform/components/navigation_bar.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/playlists_sheet.dart';
import 'package:zpevnik/screens/components/search_field.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/screens/filters/filters.dart';
import 'package:zpevnik/screens/song_lyric/song_lyric_page_view.dart';
import 'package:zpevnik/theme.dart';

class SongLyricsListView extends StatefulWidget {
  final String? searchPlaceholder;
  final String songLyricsEmptyPlaceholder;
  final String? title;

  // TODO: could this be moved to theme?
  final Color? navigationBarTextColor;
  final Color? navigationBarColor;

  const SongLyricsListView({
    Key? key,
    this.searchPlaceholder,
    this.songLyricsEmptyPlaceholder = 'Seznam neobsahuje žádné položky.',
    this.title,
    this.navigationBarTextColor,
    this.navigationBarColor,
  }) : super(key: key);

  @override
  State<SongLyricsListView> createState() => _SongLyricsListViewState();
}

class _SongLyricsListViewState extends State<SongLyricsListView> {
  final scrollController = ScrollController();
  final searchFieldFocusNode = FocusNode();

  late bool _isShowingSearchField;

  @override
  void initState() {
    super.initState();

    _isShowingSearchField = widget.title == null;
  }

  @override
  Widget build(BuildContext context) {
    final selectionEnabled = context.select<SongLyricsProvider, bool>((provider) => provider.selectionEnabled);

    final title =
        selectionEnabled ? context.select<SongLyricsProvider, String>((provider) => provider.title) : widget.title;
    final leading = selectionEnabled ? _buildCancelSelectionButton(context) : null;
    final middle =
        _shouldShowNavigationBar && _isShowingSearchField && !selectionEnabled ? _buildSearchField(context) : null;
    final trailing = _shouldShowNavigationBar && _isShowingSearchField
        ? null
        : (selectionEnabled ? _buildSelectableActions(context) : _buildSearchButton(context));

    return PlatformScaffold(
      navigationBar: PlatformNavigationBar(
        title: title,
        leading: leading,
        middle: middle,
        trailing: trailing,
        backgroundColor: widget.navigationBarColor,
        textColor: widget.navigationBarTextColor,
      ),
      body: Column(children: [
        if (!(_shouldShowNavigationBar || selectionEnabled)) _buildSearchField(context),
        Selector<SongLyricsProvider, List<Tag>>(
          builder: (_, selectedTags, __) => ActiveFiltersRow(selectedTags: selectedTags),
          selector: (_, provider) => provider.selectedTags,
        ),
        Expanded(
          child: Consumer<SongLyricsProvider>(builder: (_, provider, __) {
            if (provider.songLyrics.isEmpty) {
              return _buildSongLyricsEmptyPlaceholder(context, provider);
            } else {
              return _buildListView(context, provider);
            }
          }),
        ),
      ]),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final provider = context.read<SongLyricsProvider>();

    Widget? prefix;

    if (_shouldShowNavigationBar) {
      prefix = Highlightable(child: const Icon(Icons.arrow_back), onTap: () => _hideSearchField(context));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey('${widget.key}_search_field'),
        placeholder: widget.searchPlaceholder,
        onSearchTextChanged: (searchText) {
          provider.searchText = searchText;

          if (provider.songLyrics.isNotEmpty) {
            scrollController.animateTo(0.0, duration: kDefaultAnimationDuration, curve: Curves.easeInOut);
          }
        },
        focusNode: searchFieldFocusNode,
        prefix: prefix,
        suffix: Highlightable(child: const Icon(Icons.filter_list), onTap: () => _showFilters(context)),
        onSubmitted: (_) => _pushMatchedSongLyric(context),
      ),
    );
  }

  Widget _buildListView(BuildContext context, SongLyricsProvider provider) {
    final isReorderable = provider is Reorderable && !_isShowingSearchField;

    final child = ListView.builder(
      controller: scrollController,
      itemCount: provider.songLyrics.length,
      itemBuilder: (_, index) => SongLyricRow(
        songLyric: provider.songLyrics[index],
        searchText: provider.searchText,
        isReorderable: isReorderable,
      ),
    );

    if (isReorderable) {
      return reorderable.ReorderableList(
        onReorder: (provider as Reorderable).onReorder,
        onReorderDone: (provider as Reorderable).onReorderDone,
        child: child,
      );
    }

    return Scrollbar(controller: scrollController, child: child);
  }

  Widget _buildSongLyricsEmptyPlaceholder(BuildContext context, SongLyricsProvider provider) {
    final searchText = provider.searchText;

    final text = searchText.isNotEmpty
        ? 'Nebyl nalezen žádný výsledek pro${unbreakableSpace}hledaný výraz: "$searchText"'
        : widget.songLyricsEmptyPlaceholder;

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(child: Text(text, style: AppTheme.of(context).bodyTextStyle, textAlign: TextAlign.center)),
    );
  }

  Widget _buildSelectableActions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final iconColor = widget.navigationBarTextColor ?? appTheme.chordColor;

    return Consumer<SongLyricsProvider>(
      builder: (_, provider, __) {
        final hasSelection = provider.selectedSongLyrics.isNotEmpty;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Highlightable(
              child: Icon(provider.allFavorite ? Icons.star : Icons.star_outline),
              color: iconColor,
              onTap: hasSelection ? () => provider.toggleFavorite() : null,
            ),
            if (provider is PlaylistSongLyricsProvider)
              Highlightable(
                child: const Icon(Icons.delete),
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                color: iconColor,
                onTap: hasSelection ? () => _removeSongLyrics(context) : null,
              )
            else
              Highlightable(
                child: const Icon(Icons.playlist_add),
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                color: iconColor,
                onTap: hasSelection ? () => _showPlaylists(context) : null,
              ),
            Highlightable(
              child: const Icon(Icons.select_all),
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              color: iconColor,
              onTap: () => provider.toggleAll(),
            )
          ],
        );
      },
    );
  }

  Widget _buildCancelSelectionButton(BuildContext context) {
    return Highlightable(
      child: const Icon(Icons.close),
      color: widget.navigationBarTextColor ?? AppTheme.of(context).chordColor,
      padding: EdgeInsets.zero,
      onTap: () => context.read<SongLyricsProvider>().selectionEnabled = false,
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return Highlightable(
      child: Icon(Icons.search, color: widget.navigationBarTextColor),
      onTap: () {
        searchFieldFocusNode.requestFocus();

        setState(() => _isShowingSearchField = true);
      },
    );
  }

  bool get _shouldShowNavigationBar => widget.title != null;

  void _hideSearchField(BuildContext context) {
    final provider = context.read<SongLyricsProvider>();

    provider.searchText = '';
    provider.clearTags();

    searchFieldFocusNode.unfocus();

    setState(() => _isShowingSearchField = false);
  }

  void _showFilters(BuildContext context) {
    showPlatformBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SongLyricsProvider>(),
        builder: (context, _) => FiltersWidget(),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }

  void _showPlaylists(BuildContext context) {
    final provider = context.read<SongLyricsProvider>();

    showPlatformBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<PlaylistsProvider>(),
        builder: (_, __) => PlaylistsSheet(selectedSongLyrics: provider.selectedSongLyrics),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }

  void _removeSongLyrics(BuildContext context) async {
    final confirmed = await showPlatformDialog<bool>(
      context,
      (context) => const ConfirmDialog(
        title: 'Opravdu chcete píseň odebraz z playlistu?',
        confirmText: 'Odebrat',
      ),
    );

    if (confirmed != null && confirmed) {
      (context.read<SongLyricsProvider>() as PlaylistSongLyricsProvider).removeSongLyrics();
    }
  }

  void _pushMatchedSongLyric(BuildContext context) {
    final provider = context.read<SongLyricsProvider>();

    if (provider.matchedById != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SongLyricPageView(songLyrics: [provider.matchedById!]),
        ),
      );
    }
  }
}
