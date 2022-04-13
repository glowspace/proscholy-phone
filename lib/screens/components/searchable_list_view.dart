import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/providers/utils/searchable.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/playlists_sheet.dart';
import 'package:zpevnik/screens/components/search_field.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/screens/filters/filters.dart';
import 'package:zpevnik/theme.dart';

class SearchableListView<T, U extends Searchable<T>> extends StatefulWidget {
  final Widget Function(T) itemBuilder;
  final String searchPlaceholder;
  final String noItemsPlaceholder;

  // determines if ListView or StaggerdGridView is used
  final int crossAxisCount;

  final bool Function(Key, Key)? onReorder;
  final Function(Key)? onReorderDone;

  final String? navigationBarTitle;
  final Color? navigationBarColor;
  final Color? navigationBarTextColor;

  const SearchableListView({
    Key? key,
    required this.itemBuilder,
    this.noItemsPlaceholder = 'Seznam neobsahuje žádné položky.',
    this.searchPlaceholder = '',
    this.crossAxisCount = 1,
    this.onReorder,
    this.onReorderDone,
    this.navigationBarTitle,
    this.navigationBarColor,
    this.navigationBarTextColor,
  }) : super(key: key);

  @override
  _SearchableListViewState<T, U> createState() => _SearchableListViewState<T, U>();
}

class _SearchableListViewState<T, U extends Searchable<T>> extends State<SearchableListView<T, U>> {
  final searchFieldFocusNode = FocusNode();
  late final AutoScrollController scrollController;

  late bool _isShowingSearchField;

  TagsProvider? _tagsProvider;

  @override
  void initState() {
    super.initState();

    scrollController = AutoScrollController(suggestedRowHeight: 30);

    _isShowingSearchField = widget.navigationBarTitle == null;
  }

  @override
  Widget build(BuildContext context) {
    final searchButton = Highlightable(
      child: Icon(Icons.search, color: widget.navigationBarTextColor),
      onPressed: () {
        setState(() => _isShowingSearchField = true);

        searchFieldFocusNode.requestFocus();
      },
    );

    final provider = context.watch<U>();

    final selectionProvider = context.watch<SongLyricsProvider?>();
    final selectionEnabled = selectionProvider?.selectionEnabled ?? false;

    final title = selectionEnabled ? selectionProvider?.title : widget.navigationBarTitle;
    final leading = selectionEnabled ? _cancelSelectionAction : null;
    final middle = _shouldShowNavigationBar && _isShowingSearchField && !selectionEnabled ? _buildSearchField() : null;
    final trailing =
        _shouldShowNavigationBar && _isShowingSearchField ? null : (selectionEnabled ? Container() : searchButton);

    return PlatformScaffold(
      title: title,
      leading: leading,
      middle: middle,
      trailing: trailing,
      navigationBarColor: widget.navigationBarColor,
      navigationBarTextColor: widget.navigationBarTextColor,
      body: Column(
        children: [
          if (!(_shouldShowNavigationBar || selectionEnabled)) _buildSearchField(),
          Expanded(child: provider.items.isNotEmpty ? _buildList() : _buildNoItemWidget()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    final provider = context.read<U>();

    Widget? prefix;
    Widget? suffix;

    if (_shouldShowNavigationBar) {
      prefix = Highlightable(child: const Icon(Icons.arrow_back), onPressed: () => _hideSearchField(context));
    }
    if (provider is SongLyricsProvider) {
      suffix = Highlightable(child: const Icon(Icons.filter_list), onPressed: () => _showFilters(context));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey('${widget.key}_search_field'),
        placeholder: widget.searchPlaceholder,
        onSearchTextChanged: (searchText) {
          scrollController.animateTo(0.0, duration: kDefaultAnimationDuration, curve: Curves.easeInOut);
          provider.searchText = searchText;
        },
        focusNode: searchFieldFocusNode,
        prefix: prefix,
        suffix: suffix,
        onSubmitted: (_) => provider.onSubmitted(context),
      ),
    );
  }

  Widget _buildList() {
    final provider = context.watch<U>();

    final items = provider.items;

    final isReorderable = widget.onReorder != null && widget.onReorderDone != null;

    Widget child = widget.crossAxisCount == 1
        ? ListView.builder(
            controller: scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) => AutoScrollTag(
                key: ValueKey(index),
                controller: scrollController,
                index: index,
                child: widget.itemBuilder(items[index])),
          )
        : MasonryGridView.count(
            controller: scrollController,
            crossAxisCount: widget.crossAxisCount,
            itemCount: items.length,
            itemBuilder: (context, index) => widget.itemBuilder(items[index]),
          );

    if (isReorderable) {
      child = reorderable.ReorderableList(
        onReorder: widget.onReorder!,
        onReorderDone: widget.onReorderDone!,
        child: child,
      );
    }

    return Scrollbar(child: child, controller: scrollController);
  }

  Widget _buildNoItemWidget() {
    final provider = context.watch<U>();

    final searchText = provider.searchText;

    final text = searchText.isNotEmpty
        ? 'Nebyl nalezen žádný výsledek pro${unbreakableSpace}hledaný výraz: "$searchText"'
        : widget.noItemsPlaceholder;

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(child: Text(text, style: AppTheme.of(context).bodyTextStyle, textAlign: TextAlign.center)),
    );
  }

  Widget get _cancelSelectionAction {
    final selectionProvider = context.read<SongLyricsProvider>();

    return Highlightable(
      child: const Icon(Icons.close),
      color: AppTheme.of(context).chordColor,
      padding: EdgeInsets.zero,
      onPressed: () => selectionProvider.selectionEnabled = false,
    );
  }

  bool get _shouldShowNavigationBar => widget.navigationBarTitle != null;

  void _showFilters(BuildContext context) {
    final provider = context.read<SongLyricsProvider?>();

    if (provider != null) {
      final dataProvider = context.read<DataProvider>();
      final tagsProvider = _tagsProvider ??= TagsProvider(dataProvider.tags);

      showPlatformBottomSheet(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          builder: (context, _) => FiltersWidget(provider: tagsProvider),
        ),
        height: 0.67 * MediaQuery.of(context).size.height,
      );
    }
  }

  void _hideSearchField(BuildContext context) {
    context.read<U>().searchText = '';
    context.read<SongLyricsProvider?>()?.clearTags();

    setState(() => _isShowingSearchField = false);

    searchFieldFocusNode.unfocus();
  }
}
