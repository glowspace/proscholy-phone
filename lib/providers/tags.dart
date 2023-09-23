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

@riverpod
class SelectedTags extends _$SelectedTags {
  final List<Set<Tag>> selectedTagsStack = [];

  @override
  Set<Tag> build() {
    return {for (final tagType in supportedTagTypes) ...ref.watch(selectedTagsByTypeProvider(tagType))};
  }

  void push({Tag? initialTag}) {
    selectedTagsStack.add({for (final tagType in supportedTagTypes) ...ref.read(selectedTagsByTypeProvider(tagType))});

    for (final tagType in supportedTagTypes) {
      ref.invalidate(selectedTagsByTypeProvider(tagType));
    }

    if (initialTag != null) toggleSelection(initialTag);
  }

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

@riverpod
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
