import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/utils.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/providers/utils.dart';
import 'package:zpevnik/utils/client.dart';

part 'update.g.dart';

const _versionKey = 'current_version';

const _lastUpdateKey = 'last_update';
const _initialLastUpdate = '2023-09-29 13:00:00';

const _updatePeriod = Duration(hours: 1);

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

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

Future<void> loadInitial(WidgetRef ref) async {
  final appDependencies = ref.read(appDependenciesProvider);

  final lastVersion = appDependencies.sharedPreferences.getString(_versionKey);
  final currentVersion = '${appDependencies.packageInfo.version}+${appDependencies.packageInfo.buildNumber}';

  if (lastVersion == currentVersion) return;

  // TODO: remove this after some time, that all users have at least 3.1.0 version
  migratePinnedSongbooks(appDependencies.store, appDependencies.sharedPreferences);
  migrateSongLyricSettings(appDependencies.store);

  // TODO: remove json file after loading, this is not possible right now
  final json = jsonDecode(await rootBundle.loadString('assets/data.json'));

  await parseAndStoreData(appDependencies.store, json['data']);

  final songLyrics = await storeSongLyrics(
    appDependencies.store,
    readJsonList(json['data'][SongLyric.fieldKey], mapper: SongLyric.fromJson),
  );

  ref.read(searchedSongLyricsProvider.notifier).update(songLyrics);

  appDependencies.sharedPreferences.remove(_lastUpdateKey);
  appDependencies.sharedPreferences.setString(_versionKey, currentVersion);
}

@riverpod
Stream<UpdateStatus> update(UpdateRef ref) async* {
  final client = Client();
  final appDependencies = ref.read(appDependenciesProvider);

  ref.onDispose(client.dispose);

  // update news
  try {
    final newsItems =
        await client.getNews().then((json) => readJsonList(json[NewsItem.fieldKey], mapper: NewsItem.fromJson));

    appDependencies.store.box<NewsItem>().putMany(newsItems);
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

  await parseAndStoreData(appDependencies.store, data);

  // query existing song lyrics to check song lyrics that are missing in local db or that were removed on server
  final box = appDependencies.store.box<SongLyric>();
  final query = box.query().build();
  final existingSongLyricsIds = query.findIds().toSet();

  query.close();

  final missingSongLyricIds = <int>{};

  for (final songLyric in data['song_lyrics']) {
    final id = int.parse(songLyric['id']);

    if (!existingSongLyricsIds.contains(id)) missingSongLyricIds.add(id);

    existingSongLyricsIds.remove(id);
  }

  // remove song lyrics that were removed on server
  box.removeMany(existingSongLyricsIds.toList());

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

  ref.read(searchedSongLyricsProvider.notifier).update(updatedSongLyrics);

  yield Updated(updatedSongLyrics);

  appDependencies.sharedPreferences.setString(_lastUpdateKey, _dateFormat.format(now));
}
