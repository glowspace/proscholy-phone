import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/utils/updater.dart';
import 'package:zpevnik/utils/exceptions.dart';

class DataProvider extends ChangeNotifier {
  final updater = Updater();

  late Map<int, Playlist> _playlists;
  late Map<int, SongLyric> _songLyrics;
  late Map<int, Songbook> _songbooks;
  late List<Tag> _tags;

  late Map<int, List<SongLyric>> _songsSongLyrics;

  List<Playlist> get playlists => _playlists.values.toList();
  List<SongLyric> get songLyrics => _songLyrics.values.toList();
  List<Songbook> get songbooks => _songbooks.values.toList();
  List<Tag> get tags => _tags;

  List<SongLyric> songbookSongLyrics(Songbook songbook) {
    final songLyrics = List<SongLyric>.empty(growable: true);

    for (final record in songbook.records) {
      final songLyric = _songLyrics[record.songLyricId];

      if (songLyric != null) songLyrics.add(songLyric);
    }

    return songLyrics;
  }

  List<SongLyric> playlistSongLyrics(Playlist playlist) {
    final songLyrics = List<SongLyric>.empty(growable: true);

    for (final songLyricId in playlist.songLyrics) {
      final songLyric = _songLyrics[songLyricId];

      if (songLyric != null) songLyrics.add(songLyric);
    }

    return songLyrics;
  }

  List<SongLyric>? songsSongLyrics(int songId) => _songsSongLyrics[songId];

  Future<bool> update({bool forceUpdate = false}) async {
    bool updated;

    try {
      await updater.update(forceUpdate);

      updated = true;
    } on UpdateException {
      Fluttertoast.showToast(
        msg: 'Během aktualizace písní nastala chyba.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      updated = false;
    }

    _playlists = Map.fromIterable(await Playlist.playlists, key: (element) => element.id);
    _songLyrics = Map.fromIterable(await SongLyric.songLyrics, key: (element) => element.id);
    _songbooks = Map.fromIterable(await Songbook.songbooks, key: (element) => element.id);
    _tags = await Tag.tags;

    _addLanguagesToTags();

    _songsSongLyrics = Map<int, List<SongLyric>>.from({});

    for (final songLyric in songLyrics) {
      final songId = songLyric.songId;
      if (songId == null) continue;

      if (!_songsSongLyrics.containsKey(songId)) _songsSongLyrics[songId] = List<SongLyric>.empty(growable: true);

      _songsSongLyrics[songId]?.add(songLyric);
    }

    if (forceUpdate) notifyListeners();

    return updated;
  }

  void _addLanguagesToTags() {
    final languages = Map<String, int>.from({});

    for (final songLyric in songLyrics) {
      if (!languages.containsKey(songLyric.language)) languages[songLyric.language] = 0;

      languages[songLyric.language] = languages[songLyric.language]! + 1;
    }

    final languageTags = List<Tag>.empty(growable: true);

    for (final language in languages.keys) {
      final tag = Tag(model.Tag(name: language, type_enum: 'LANGUAGE'));

      languageTags.add(tag);
    }

    languageTags.sort((first, second) => -languages[first.name]!.compareTo(languages[second.name]!));

    _tags.addAll(languageTags);
  }
}
