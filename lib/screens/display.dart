import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/bible_verse.dart';
import 'package:zpevnik/components/playlist/custom_text.dart';
import 'package:zpevnik/components/playlist/playlists_sheet.dart';
import 'package:zpevnik/components/presentation/presentation.dart';
import 'package:zpevnik/components/selected_displayable_item_index.dart';
import 'package:zpevnik/components/presentation/settings.dart';
import 'package:zpevnik/components/song_lyric/bottom_bar.dart';
import 'package:zpevnik/components/song_lyric/externals/collapsed_player.dart';
import 'package:zpevnik/components/song_lyric/externals/externals_wrapper.dart';
import 'package:zpevnik/components/song_lyric/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_menu_button.dart';
import 'package:zpevnik/components/song_lyric/utils/active_player_controller.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/providers/auto_scroll.dart';
import 'package:zpevnik/providers/menu_collapsed.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/providers/display_screen_status.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/utils/extensions.dart';

class DisplayScreen extends StatelessWidget {
  final List<DisplayableItem> items;
  final int initialIndex;

  final Playlist? playlist;

  const DisplayScreen({super.key, required this.items, this.initialIndex = 0, this.playlist});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet) {
      return _DisplayScreenTablet(items: items, initialIndex: initialIndex, playlist: playlist);
    }

    return _DisplayScaffold(items: items, initialIndex: initialIndex);
  }
}

class _DisplayScreenTablet extends ConsumerStatefulWidget {
  final List<DisplayableItem> items;
  final int initialIndex;

  final Playlist? playlist;

  const _DisplayScreenTablet({required this.items, required this.initialIndex, this.playlist});

  @override
  ConsumerState<_DisplayScreenTablet> createState() => _DisplayScreenTabletState();
}

class _DisplayScreenTabletState extends ConsumerState<_DisplayScreenTablet> {
  late final _selectedDisplayableItemIndex = ValueNotifier(widget.initialIndex);

  @override
  Widget build(BuildContext context) {
    return SelectedDisplayableItemIndex(
      displayableItemIndexNotifier: _selectedDisplayableItemIndex,
      child: SplitView(
        childFlex: 3,
        detailFlex: 7,
        showingOnlyDetail: ref.watch(menuCollapsedProvider),
        detail: ValueListenableBuilder(
          valueListenable: _selectedDisplayableItemIndex,
          builder: (_, index, __) => _DisplayScaffold(key: Key('$index'), items: widget.items, initialIndex: index),
        ),
        child: widget.playlist == null ? const SearchScreen() : PlaylistScreen(playlist: widget.playlist!),
      ),
    );
  }
}

class _DisplayScaffold extends ConsumerStatefulWidget {
  final List<DisplayableItem> items;
  final int initialIndex;

  const _DisplayScaffold({super.key, required this.items, required this.initialIndex});

  @override
  ConsumerState<_DisplayScaffold> createState() => _DisplayScaffoldState();
}

class _DisplayScaffoldState extends ConsumerState<_DisplayScaffold> {
  // make sure it is possible to swipe to previous item
  // this controller is only used to set the initial page
  late final _controller = PageController(initialPage: widget.initialIndex + 100 * widget.items.length);

  late int _currentIndex;

  late double _fontSizeScaleBeforeScale;

  Timer? _addRecentItemTimer;

  DisplayableItem get _currentItem => widget.items[_currentIndex % widget.items.length];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _addRecentItemTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // update media query with font size scale from settings, so all children has correct font size scale and it does not have to be set individually
    final newMediaQuery = MediaQuery.of(context)
        .copyWith(textScaleFactor: ref.watch(settingsProvider.select((settings) => settings.fontSizeScale)));

    final fullScreen = ref.watch(displayScreenStatusProvider.select((status) => status.fullScreen));

    final scaffold = CustomScaffold(
      appBar: fullScreen ? null : _buildAppBar(),
      bottomSheet: _buildBottomSheet(),
      bottomNavigationBar: fullScreen
          ? const SizedBox()
          : SongLyricBottomBar(
              songLyric: _currentItem.whenOrNull(songLyric: (songLyric) => songLyric),
              autoScrollController: ref.read(autoScrollControllerProvider(_currentItem)),
            ),
      body: GestureDetector(
        onScaleStart: _fontScaleStarted,
        onScaleUpdate: _fontScaleUpdated,
        onTap: ref.read(displayScreenStatusProvider.notifier).toggleFullScreen,
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: MediaQuery(
            data: newMediaQuery,
            child: PageView.builder(
              controller: widget.items.length == 1 ? null : _controller,
              onPageChanged: _itemChanged,
              itemCount: widget.items.length == 1 ? 1 : null,
              // disable scrolling when there is only one item
              physics: widget.items.length == 1 ? const NeverScrollableScrollPhysics() : null,
              itemBuilder: (_, index) {
                final item = widget.items[index % widget.items.length];

                if (ref.watch(presentationProvider
                    .select((presentation) => presentation.isPresenting && presentation.isPresentingLocally))) {
                  if (ref.watch(
                      presentationProvider.select((presentation) => presentation.showingData.name == item.name))) {
                    return StreamBuilder(
                      stream: ref.read(presentationProvider).showingDataStream,
                      builder: (_, dataSnaphost) => Presentation(
                        onExternalDisplay: false,
                        presentationData: dataSnaphost.data ?? defaultPresentationData,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }

                final autoScrollController = ref.read(autoScrollControllerProvider(item));

                return item.when(
                  bibleVerse: (bibleVerse) => BibleVerseWidget(
                    bibleVerse: bibleVerse,
                    autoScrollController: autoScrollController,
                  ),
                  customText: (customText) => CustomTextWidget(
                    customText: customText,
                    autoScrollController: autoScrollController,
                  ),
                  songLyric: (songLyric) => SongLyricWidget(
                    songLyric: songLyric,
                    autoScrollController: autoScrollController,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    // FIXME: it must be wrapped, even when it is not song lyric, otherwise the pageview is initialized again and displayed content does not make sense
    return ExternalsWrapper(songLyric: _currentItem.whenOrNull(songLyric: (songLyric) => songLyric), child: scaffold);
  }

  PreferredSizeWidget? _buildAppBar() {
    return _currentItem.when(
      bibleVerse: (bibleVerse) => AppBar(
        leading: const CustomBackButton(),
        title: Text(bibleVerse.name),
        actions: [
          Highlightable(
            onTap: () => _editBibleVerse(bibleVerse),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      customText: (customText) => AppBar(
        leading: const CustomBackButton(),
        title: Text(customText.name),
        actions: [
          Highlightable(
            onTap: () => _editCustomText(customText),
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      songLyric: (songLyric) => AppBar(
        title: Text('${songLyric.id}'),
        leading: const CustomBackButton(),
        actions: [
          StatefulBuilder(
            builder: (context, setState) => Highlightable(
              onTap: () => setState(() => ref.read(playlistsProvider.notifier).toggleFavorite(songLyric)),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              icon: Icon(songLyric.isFavorite ? Icons.star : Icons.star_outline),
            ),
          ),
          Highlightable(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => PlaylistsSheet(selectedSongLyric: songLyric),
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            icon: const Icon(Icons.playlist_add),
          ),
          SongLyricMenuButton(songLyric: songLyric),
        ],
      ),
    );
  }

  Widget? _buildBottomSheet() {
    final activePlayer = ref.watch(activePlayerProvider);
    final presentation = ref.watch(presentationProvider);
    final fullScreen = ref.watch(displayScreenStatusProvider.select((status) => status.fullScreen));

    if (presentation.isPresenting) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding) +
            EdgeInsets.only(bottom: fullScreen ? MediaQuery.paddingOf(context).bottom : 0),
        child: Row(children: [
          Highlightable(
            onTap: presentation.prevVerse,
            icon: Icon(Icons.adaptive.arrow_back),
          ),
          Highlightable(
            onTap: presentation.togglePause,
            icon: Icon(presentation.isPaused ? Icons.play_arrow : Icons.pause),
          ),
          Highlightable(
            onTap: presentation.nextVerse,
            icon: Icon(Icons.adaptive.arrow_forward),
          ),
          const Spacer(),
          Highlightable(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => PresentationSettingsWidget(
                onExternalDisplay: ref.read(
                  presentationProvider.select((presentation) => !presentation.isPresentingLocally),
                ),
              ),
            ),
            icon: const Icon(Icons.tune),
          ),
          Highlightable(
            onTap: () => presentation.stop(),
            icon: const Icon(Icons.close),
          ),
        ]),
      );
    } else if (activePlayer != null) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: ref.read(displayScreenStatusProvider.notifier).showExternals,
        child: CollapsedPlayer(
          controller: activePlayer,
          onDismiss: ref.read(activePlayerProvider.notifier).dismiss,
        ),
      );
    }

    return null;
  }

  void _itemChanged(int index) {
    setState(() => _currentIndex = index);

    // notify presentation
    ref.read(presentationProvider.notifier).change(_currentItem);

    // change highligh index on tablet
    final selectedDisplayableItemIndexNotifier = SelectedDisplayableItemIndex.of(context);

    if (selectedDisplayableItemIndexNotifier != null) {
      selectedDisplayableItemIndexNotifier.value = index % widget.items.length;
    }

    // saves item as recent if it was at least for 2 seconds on screen
    _addRecentItemTimer?.cancel();
    _addRecentItemTimer =
        Timer(const Duration(seconds: 2), () => ref.read(recentItemsProvider.notifier).add(_currentItem));

    ref.read(activePlayerProvider.notifier).dismiss();
  }

  void _fontScaleStarted(ScaleStartDetails _) {
    _fontSizeScaleBeforeScale = ref.read(settingsProvider.select((settings) => settings.fontSizeScale));
  }

  void _fontScaleUpdated(ScaleUpdateDetails details) {
    ref.read(settingsProvider.notifier).changeFontSizeScale(_fontSizeScaleBeforeScale * details.scale);
  }

  void _editBibleVerse(BibleVerse bibleVerse) async {
    final editedBibleVerse =
        (await context.push('/playlist/bible_verse/select_verse', arguments: bibleVerse)) as BibleVerse?;

    if (editedBibleVerse != null) {
      setState(() => widget.items[_currentIndex] = DisplayableItem.bibleVerse(editedBibleVerse));
    }
  }

  void _editCustomText(CustomText customText) async {
    final editedCustomText = (await context.push('/playlist/custom_text/edit', arguments: customText)) as CustomText?;

    if (editedCustomText != null) {
      setState(() => widget.items[_currentIndex] = DisplayableItem.customText(editedCustomText));
    }
  }
}
