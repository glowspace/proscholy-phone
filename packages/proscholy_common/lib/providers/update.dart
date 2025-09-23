import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:proscholy_common/models/news_item.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/utils.dart';
import 'package:proscholy_common/utils/client.dart';
import 'package:proscholy_common/utils/services/spotlight.dart';

part 'generated/update.g.dart';

const _versionKey = 'current_version';

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = isZP ? '2025-03-17 09:00:00' : (isEZ ? '2025-09-23 09:00:00' : '2025-06-17 09:00:00');

const _updatePeriod = Duration(hours: 1);

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

@Riverpod(keepAlive: true)
Client graphQLClient(Ref ref) => Client();

sealed class UpdateStatus {
  const UpdateStatus();
}

class Updating extends UpdateStatus {
  const Updating();
}

class Updated extends UpdateStatus {
  final List<SongLyric> songLyrics;

  const Updated(this.songLyrics);
}

Future<void> loadInitial(AppDependencies appDependencies) async {
  _cleanup(appDependencies);

  final lastVersion = appDependencies.sharedPreferences.getString(_versionKey);
  final currentVersion = '${appDependencies.packageInfo.version}+${appDependencies.packageInfo.buildNumber}';

  if (lastVersion == currentVersion) return;

  // TODO: remove json file after loading, this is not possible right now
  final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

  await parseAndStoreData(appDependencies.store, json['data']);

  final songLyrics = await storeSongLyrics(
    appDependencies.store,
    readJsonList(json['data'][SongLyric.fieldKey], mapper: SongLyric.fromJson),
  );

  // drop "song_lyrics_search" table as there might be change in structure from last version
  try {
    await appDependencies.ftsDatabase.execute('DROP TABLE song_lyrics_search');
  } on DatabaseException {} // ignore exceptions if database does not exist
  SearchedSongLyrics.update(appDependencies.ftsDatabase, songLyrics);

  appDependencies.sharedPreferences.remove(_lastUpdateKey);
  appDependencies.sharedPreferences.setString(_versionKey, currentVersion);
}

@riverpod
Stream<UpdateStatus> update(Ref ref) async* {
  final client = ref.read(graphQLClientProvider);
  final appDependencies = ref.read(appDependenciesProvider);

  // update news
  try {
    final newsItems =
        await client.getNews().then((json) => readJsonList(json[NewsItem.fieldKey], mapper: NewsItem.fromJson));

    // remove all news items, that were deleted on server
    appDependencies.store.box<NewsItem>().removeAll();
    appDependencies.store.box<NewsItem>().putMany(newsItems);
  } on OperationException catch (e) {
    if (e.linkException?.originalException is SocketException) return;
  } on SocketException {
    return;
  }

  // check if update should happen
  final now = DateTime.now().toUtc();
  final lastUpdate =
      _dateFormat.parseUtc(appDependencies.sharedPreferences.getString(_lastUpdateKey) ?? _initialLastUpdate);

  if (now.isBefore(lastUpdate.add(_updatePeriod))) return;

  yield const Updating();

  final data = await client.getData();

  ref.read(svgsProvider.notifier).storeSvgs(await client.getSvgs(lastUpdate));

  await parseAndStoreData(appDependencies.store, data);

  // query existing song lyrics to check song lyrics that are missing in local db or that were removed on server
  final box = appDependencies.store.box<SongLyric>();
  final query = box.query().build();
  final existingSongLyricsIds = query.property(SongLyric_.id).find().toSet();

  query.close();

  final missingSongLyricIds = <int>{};

  for (final songLyric in data['song_lyrics']) {
    final id = int.parse(songLyric['id']);

    if (!existingSongLyricsIds.contains(id)) missingSongLyricIds.add(id);

    existingSongLyricsIds.remove(id);
  }

  // remove song lyrics that were removed on server
  box.removeMany(existingSongLyricsIds.toList());

  // on iOS also remove them from spotlight indexing
  SpotlightService.instance.deindexItems(existingSongLyricsIds.map((id) => 'song_lyric_$id').toList());

  // update song lyrics
  final songLyrics = await client
      .getSongLyrics(lastUpdate)
      .then((json) => readJsonList(json[SongLyric.fieldKey], mapper: SongLyric.fromJson));

  for (final songLyric in songLyrics) {
    missingSongLyricIds.remove(songLyric.id);
  }

  // fetch missing song lyrics
  final List<Future<SongLyric>> futures = [];

  for (final songLyricId in missingSongLyricIds) {
    futures.add(client.getSongLyric(songLyricId).then((json) => SongLyric.fromJson(json)));
  }

  songLyrics.addAll(await Future.wait(futures));

  final updatedSongLyrics = await storeSongLyrics(appDependencies.store, songLyrics);

  _cleanup(appDependencies);

  SearchedSongLyrics.update(appDependencies.ftsDatabase, updatedSongLyrics);

  yield Updated(updatedSongLyrics);

  appDependencies.sharedPreferences.setString(_lastUpdateKey, _dateFormat.format(now));
}

// FIXME: does not seem to work correctly? try removing based on song_lyric ids
void _cleanup(AppDependencies appDependencies) async {
  // remove externals that were associated with removed song lyrics
  _removeRelations(appDependencies.store, External_.songLyric.equals(0));

  // remove songbook records that were associated with removed song lyrics
  _removeRelations(appDependencies.store, SongbookRecord_.songLyric.equals(0));

  // remove playlist records that were associated with removed song lyrics
  _removeRelations(
    appDependencies.store,
    PlaylistRecord_.songLyric
        .equals(0)
        .and(PlaylistRecord_.bibleVerse.equals(0))
        .and(PlaylistRecord_.customText.equals(0)),
  );

  // remove shared playlists
  final dir = await getApplicationDocumentsDirectory();
  final files = dir.listSync();

  for (final file in files) {
    if (file is File && file.path.endsWith('.proscholy')) {
      print(file);
      try {
        await file.delete();
      } catch (_) {}
    }
  }
}

void _removeRelations<T>(Store store, Condition<T> condition) {
  final box = store.box<T>();
  final query = box.query(condition).build();

  box.removeMany(query.findIds());

  query.close();
}
