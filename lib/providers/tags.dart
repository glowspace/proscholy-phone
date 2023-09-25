import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/providers/utils.dart';

part 'tags.g.dart';

// provides tags for given `tagType`
// for songbooks, playlists and languages it creates corresponding tags,
// remaining tags are queried from objectbox store
@riverpod
List<Tag> tags(TagsRef ref, TagType tagType) {
  switch (tagType) {
    case TagType.songbook:
      final songbooks = ref.watch(songbooksProvider);

      return songbooks.map((songbook) => songbook.tag).toList();
    case TagType.playlist:
      final playlists = [ref.read(favoritePlaylistProvider)] + ref.watch(playlistsProvider);

      return playlists.map((playlist) => playlist.tag).toList();
    case TagType.language:
      final languageCounts = <String, int>{};

      for (final songLyric in ref.read(songLyricsProvider)) {
        languageCounts[songLyric.langDescription] = (languageCounts[songLyric.langDescription] ?? 0) + 1;
      }

      final languages = languageCounts.keys.sorted((a, b) => languageCounts[b]!.compareTo(languageCounts[a]!));

      int id = -1;

      return [for (final language in languages) Tag(id: id--, name: language, dbType: tagType.rawValue)];
    default:
      final tags = queryStore(ref, condition: Tag_.dbType.equals(tagType.rawValue));

      return tags;
  }
}

// provides set of selected tags
// because there might be multiple search screens in stack that use this provider, it is keeping info about selected tags for different screens
@Riverpod(keepAlive: true)
class SelectedTags extends _$SelectedTags {
  final List<Set<Tag>> selectedTagsStack = [];

  @override
  Set<Tag> build() {
    return {for (final tagType in supportedTagTypes) ...ref.watch(selectedTagsByTypeProvider(tagType))};
  }

  // prepares state for new search screen with optional `initialTag` by storing current state and invalidating all providers
  // is called when starting search from `PlaylistScreen`, `SongbookScreen` or `SongLyricTag`
  void push({Tag? initialTag}) {
    if (state.isNotEmpty) selectedTagsStack.add(state);

    for (final tagType in supportedTagTypes) {
      ref.invalidate(selectedTagsByTypeProvider(tagType));
    }

    if (initialTag != null) toggleSelection(initialTag);
  }

  // restores state of previous search screen
  // is called in `onWillPop` function in `SearchScreen`
  void pop() {
    for (final tagType in supportedTagTypes) {
      ref.invalidate(selectedTagsByTypeProvider(tagType));
    }

    if (selectedTagsStack.isNotEmpty) {
      for (final tag in selectedTagsStack.removeLast()) {
        toggleSelection(tag);
      }
    }
  }

  void toggleSelection(Tag tagToToggle) {
    ref.read(selectedTagsByTypeProvider(tagToToggle.type).notifier)._toggleSelection(tagToToggle);
  }
}

@Riverpod(keepAlive: true)
class SelectedTagsByType extends _$SelectedTagsByType {
  @override
  Set<Tag> build(TagType tagType) => {};

  void _toggleSelection(Tag tagToToggle) {
    if (state.contains(tagToToggle)) {
      state = {
        for (final tag in state)
          if (tag != tagToToggle) tag
      };
    } else {
      state = {tagToToggle, ...state};
    }
  }
}
