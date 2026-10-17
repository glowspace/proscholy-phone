import 'package:proscholy_common/models/author.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/songbook_record.dart';
import 'package:proscholy_common/models/spotlight_item.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/utils/services/spotlight.dart';

final _chordRE = RegExp(r'\[[^\]]+\]');

Future<void> parseAndStoreData(Store store, Map<String, dynamic> json) async {
  final authors = readJsonList(json[Author.fieldKey], mapper: Author.fromJson);
  final songs = readJsonList(json[Song.fieldKey], mapper: Song.fromJson);
  final songbooks = readJsonList(json[Songbook.fieldKey], mapper: Songbook.fromJson);
  final tags = readJsonList(json['tags_enum'], mapper: Tag.fromJson);

  await Future.wait([
    store.box<Author>().putManyAsync(authors),
    store.box<Song>().putManyAsync(songs),
    store.box<Songbook>().putManyAsync(songbooks),
    store.box<Tag>().putManyAsync(tags),
  ]);
}

// removes authors, songs, songbooks and tags that were removed on server
void removeMissingData(Store store, Map<String, dynamic> json) {
  _removeMissing(store, Author_.id, json[Author.fieldKey]);
  _removeMissing(store, Song_.id, json[Song.fieldKey]);
  _removeMissing(store, Songbook_.id, json[Songbook.fieldKey]);
  _removeMissing(store, Tag_.id, json['tags_enum']);

  // removing songbooks sets relations of their records to 0, records without songbook can't be shown
  final query = store.box<SongbookRecord>().query(SongbookRecord_.songbook.equals(0)).build();

  query.remove();
  query.close();
}

void _removeMissing<T>(Store store, QueryIntegerProperty<T> idProperty, List<dynamic>? jsonList) {
  // empty list is more likely an error on server, it would remove everything
  if (jsonList == null || jsonList.isEmpty) return;

  final ids = {for (final json in jsonList) int.parse(json['id'])};
  final query = store.box<T>().query().build();
  final removedIds = query.property(idProperty).find().where((id) => !ids.contains(id)).toList();

  query.close();

  store.box<T>().removeMany(removedIds);
}

Future<List<SongLyric>> storeSongLyrics(Store store, List<SongLyric> songLyrics) async {
  // filter arrangements
  songLyrics = songLyrics.where((songLyric) => !songLyric.isArrangement).toList();

  final externals = <External>[];
  final songbookRecords = <SongbookRecord>[];

  // query song lyrics with settings to preserve the relations after update
  final query = store.box<SongLyric>().query(SongLyric_.settings.notNull()).build();
  final songLyricsWithSettings = {for (final songLyric in query.find()) songLyric.id: songLyric};

  query.close();

  for (final songLyric in songLyrics) {
    externals.addAll(
      songLyric.externals.map((external) => external.copyWith(songLyric: ToOne(targetId: songLyric.id))),
    );
    songbookRecords.addAll(songLyric.songbookRecords);

    if (songLyricsWithSettings.containsKey(songLyric.id)) {
      songLyric.settings.targetId = songLyricsWithSettings[songLyric.id]!.settings.targetId;
    }
  }

  final songLyricIds = await store.box<SongLyric>().putManyAsync(songLyrics);

  // previous externals and songbook records are removed, as some of them might have been removed on server
  final externalsQuery = (store.box<External>().query()..link(External_.songLyric, SongLyric_.id.oneOf(songLyricIds)))
      .build();
  final songbookRecordsQuery =
      (store.box<SongbookRecord>().query()..link(SongbookRecord_.songLyric, SongLyric_.id.oneOf(songLyricIds))).build();

  externalsQuery.remove();
  songbookRecordsQuery.remove();

  externalsQuery.close();
  songbookRecordsQuery.close();

  await Future.wait([
    store.box<External>().putManyAsync(externals),
    store.box<SongbookRecord>().putManyAsync(songbookRecords),
  ]);

  // index new song lyrics on iOS
  SpotlightService.instance.indexItems(
    songLyrics
        .map(
          (songLyric) => SpotlightItem(
            identifier: 'song_lyric_${songLyric.id}',
            title: songLyric.name,
            description: songLyric.lyrics?.replaceAll(_chordRE, '') ?? '',
          ),
        )
        .toList(),
  );

  // retrieve the updated song lyrics with correctly setup relations
  return (await store.box<SongLyric>().getManyAsync(songLyricIds)).cast();
}
