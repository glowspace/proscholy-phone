import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/components/scaffold.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/selection.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/providers/utils/searchable.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/search_field.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/screens/filters/filters.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

class SearchableListView<T> extends StatefulWidget {
  final Searchable<T> itemsProvider;
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

  final Widget? trailingActions;

  const SearchableListView({
    Key? key,
    required this.itemsProvider,
    required this.itemBuilder,
    this.noItemsPlaceholder = 'Seznam neobsahuje žádné položky.',
    this.searchPlaceholder = '',
    this.crossAxisCount = 1,
    this.onReorder,
    this.onReorderDone,
    this.navigationBarTitle,
    this.navigationBarColor,
    this.navigationBarTextColor,
    this.trailingActions,
  }) : super(key: key);

  @override
  _SearchableListViewState createState() => _SearchableListViewState();
}

class _SearchableListViewState extends State<SearchableListView> with Updateable {
  final searchFieldFocusNode = FocusNode();

  late bool _isShowingSearchField;

  TagsProvider? _tagsProvider;

  @override
  void initState() {
    super.initState();

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

    final provider = widget.itemsProvider;

    final selectionProvider = context.read<SelectionProvider?>();
    final isSelectionEnabled = selectionProvider?.isSelectionEnabled ?? false;

    final title = isSelectionEnabled ? selectionProvider?.title : widget.navigationBarTitle;
    final leading = isSelectionEnabled ? _cancelSelectionAction : null;
    final middle =
        _shouldShowNavigationBar && _isShowingSearchField && !isSelectionEnabled ? _buildSearchField() : null;
    final trailing = _shouldShowNavigationBar && _isShowingSearchField
        ? null
        : (isSelectionEnabled ? widget.trailingActions : searchButton);

    return PlatformScaffold(
      title: title,
      leading: leading,
      middle: middle,
      trailing: trailing,
      navigationBarColor: widget.navigationBarColor,
      navigationBarTextColor: widget.navigationBarTextColor,
      body: Column(
        children: [
          if (!(_shouldShowNavigationBar || isSelectionEnabled)) _buildSearchField(),
          if (provider is SongLyricsProvider) ActiveFiltersRow(selectedTags: provider.selectedTags),
          Expanded(child: widget.itemsProvider.items.isNotEmpty ? _buildList() : _buildNoItemWidget()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    final isFilterable = widget.itemsProvider is SongLyricsProvider;
    final prefix = Highlightable(child: Icon(Icons.arrow_back), onPressed: _hideSearchField);
    final suffix = Highlightable(child: Icon(Icons.filter_list), onPressed: () => _showFilters(context));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SearchField(
        key: PageStorageKey(widget.key.toString() + '_search_field'),
        placeholder: widget.searchPlaceholder,
        onSearch: (searchText) => widget.itemsProvider.searchText = searchText,
        focusNode: searchFieldFocusNode,
        prefix: _shouldShowNavigationBar ? prefix : null,
        suffix: isFilterable ? suffix : null,
        onSubmitted: (_) => widget.itemsProvider.onSubmitted(context),
      ),
    );
  }

  Widget _buildList() {
    final items = widget.itemsProvider.items;

    final isReorderable = widget.onReorder != null && widget.onReorderDone != null;

    Widget child = widget.crossAxisCount == 1
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => widget.itemBuilder(items[index]),
          )
        : StaggeredGridView.countBuilder(
            crossAxisCount: widget.crossAxisCount,
            itemCount: items.length,
            itemBuilder: (context, index) => widget.itemBuilder(items[index]),
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          );

    if (isReorderable)
      child = reorderable.ReorderableList(
        onReorder: widget.onReorder!,
        onReorderDone: widget.onReorderDone!,
        child: child,
      );

    return Container(
      padding: EdgeInsets.only(top: kDefaultPadding / 2),
      child: Scrollbar(child: child),
    );
  }

  Widget _buildNoItemWidget() {
    final searchText = widget.itemsProvider.searchText;

    final text = searchText.isNotEmpty
        ? 'Nebyl nalezen žádný výsledek pro${unbreakableSpace}hledaný výraz: "$searchText"'
        : widget.noItemsPlaceholder;

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(child: Text(text, style: AppTheme.of(context).bodyTextStyle, textAlign: TextAlign.center)),
    );
  }

  Widget get _cancelSelectionAction {
    final selectionProvider = context.read<SelectionProvider>();

    return Highlightable(
      child: Icon(Icons.close),
      color: AppTheme.of(context).chordColor,
      padding: EdgeInsets.zero,
      onPressed: () => selectionProvider.isSelectionEnabled = false,
    );
  }

  bool get _shouldShowNavigationBar => widget.navigationBarTitle != null;

  void _showFilters(BuildContext context) {
    final provider = widget.itemsProvider;

    if (provider is SongLyricsProvider) {
      final dataProvider = context.read<DataProvider>();
      final tagsProvider = _tagsProvider ??= TagsProvider(dataProvider.tags);

      return showPlatformBottomSheet(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          builder: (context, _) => FiltersWidget(provider: tagsProvider),
        ),
        height: 0.67 * MediaQuery.of(context).size.height,
      );
    }
  }

  void _hideSearchField() {
    final provider = widget.itemsProvider;

    provider.searchText = '';

    if (provider is SongLyricsProvider) provider.clearTags();

    setState(() => _isShowingSearchField = false);

    searchFieldFocusNode.unfocus();
  }

  @override
  List<Listenable> get listenables {
    final listenables = List<Listenable>.empty(growable: true);
    listenables.add(widget.itemsProvider);

    final selectionProvider = context.read<SelectionProvider?>();
    if (selectionProvider != null) listenables.add(selectionProvider);

    return listenables;
  }
}
