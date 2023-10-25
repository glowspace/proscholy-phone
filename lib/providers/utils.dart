import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/spotlight_item.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/models/utils.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/utils/services/spotlight.dart';

final _chordRE = RegExp(r'\[[^\]]+\]');

Future<void> parseAndStoreData(Store store, Map<String, dynamic> json) async {
  final authors = readJsonList(json[Author.fieldKey], mapper: Author.fromJson);
  final songs = readJsonList(json[Song.fieldKey], mapper: Song.fromJson);
  final songbooks = readJsonList(json[Songbook.fieldKey], mapper: Songbook.fromJson);
  final tags = readJsonList(json[Tag.fieldKey], mapper: Tag.fromJson);

  await Future.wait([
    store.box<Author>().putManyAsync(authors),
    store.box<Song>().putManyAsync(songs),
    store.box<Songbook>().putManyAsync(songbooks),
    store.box<Tag>().putManyAsync(tags),
  ]);
}

Future<List<SongLyric>> storeSongLyrics(Store store, List<SongLyric> songLyrics) async {
  final externals = <External>[];
  final songbookRecords = <SongbookRecord>[];

  // query song lyrics with settings to preserve the relations after update
  final query = store.box<SongLyric>().query(SongLyric_.settings.notNull()).build();
  final songLyricsWithSettings = {for (final songLyric in query.find()) songLyric.id: songLyric};

  query.close();

  for (final songLyric in songLyrics) {
    externals.addAll(songLyric.externals);
    songbookRecords.addAll(songLyric.songbookRecords);

    if (songLyricsWithSettings.containsKey(songLyric.id)) {
      songLyric.settings.targetId = songLyricsWithSettings[songLyric.id]!.settings.targetId;
    }
  }

  final songLyricIds = await store.box<SongLyric>().putManyAsync(songLyrics);

  await Future.wait([
    store.box<External>().putManyAsync(externals),
    store.box<SongbookRecord>().putManyAsync(songbookRecords),
  ]);

  // index new song lyrics on iOS
  if (Platform.isIOS) {
    SpotlightService.instance.indexItems(songLyrics
        .map((songLyric) => SpotlightItem(
              identifier: 'song_lyric_${songLyric.id}',
              title: songLyric.name,
              description: songLyric.lyrics?.replaceAll(_chordRE, '') ?? '',
            ))
        .toList());
  }

  // retrieve the updated song lyrics with correctly setup relations
  return (await store.box<SongLyric>().getManyAsync(songLyricIds)).cast();
}

int nextId<T extends Identifiable, D>(Ref ref, QueryProperty<T, D> idProperty) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<T>()));
  final queryBuilder = box.query()..order(idProperty, flags: Order.descending);
  final query = queryBuilder.build();
  final lastId = query.findFirst()?.id ?? 0;

  query.close();

  return lastId + 1;
}

List<T> queryStore<T, D>(
  Ref ref, {
  Condition<T>? condition,
  QueryProperty<T, D>? orderBy,
  // default ascending
  int orderFlags = 0,
}) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<T>()));
  final queryBuilder = box.query(condition);

  if (orderBy != null) queryBuilder.order(orderBy, flags: orderFlags);

  final query = queryBuilder.build();
  final data = query.find();

  query.close();

  return data;
}
