import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/providers/util.dart';

part 'tags.g.dart';

@riverpod
List<Tag> tags(TagsRef ref, TagType tagType) {
  switch (tagType) {
    case TagType.songbook:
      final songbooks = ref.watch(songbooksProvider);

      int id = -1000;
      return [for (final songbook in songbooks) Tag(id: id--, name: songbook.name, dbType: tagType.rawValue)];
    case TagType.playlist:
      final playlists = [ref.read(favoritePlaylistProvider)] + ref.watch(playlistsProvider);

      int id = -2000;
      return [for (final playlist in playlists) Tag(id: id--, name: playlist.name, dbType: tagType.rawValue)];
    case TagType.language:
      return [];
    default:
      final tags = queryStore(ref, condition: Tag_.dbType.equals(tagType.rawValue));

      return tags;
  }
}

@riverpod
class SelectedTagsByType extends _$SelectedTagsByType {
  @override
  Set<Tag> build(TagType tagType) => {};

  void toggleSelection(Tag tagToToggle) {
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

@riverpod
Set<Tag> selectedTags(SelectedTagsRef ref) {
  return {for (final tagType in supportedTagTypes) ...ref.watch(selectedTagsByTypeProvider(tagType))};
}
