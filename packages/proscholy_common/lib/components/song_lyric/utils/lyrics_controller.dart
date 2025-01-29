import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/components/song_lyric/utils/parser.dart';

final _viewBoxRE = RegExp(r'<svg[^>]* viewBox="0 0 ([\d\.]+) ([\d\.]+)"[^>]*>');
final _sizeRE = RegExp(r'width="([\d\.]+)[^"]*" height="([\d\.]+)[^"]*"');

class LyricsController extends AssetBundle {
  final SongLyric songLyric;
  final SongLyricsParser parser;

  final BuildContext context;

  LyricsController(this.songLyric, this.context) : parser = SongLyricsParser(songLyric);

  double? _musicNotesWidth;
  double? _musicNotesMaxWidth;
  String? _musicNotes;

  String get title => songLyric.name;

  bool get hasMusicNotes => songLyric.musicNotes != null;

  double get musicNotesWidth => _musicNotesWidth ?? 0;
  double get musicNotesMaxWidth => _musicNotesMaxWidth ?? 0;

  String get musicNotes {
    if (_musicNotes != null) return _musicNotes!;

    final viewBoxMatch = _viewBoxRE.firstMatch(songLyric.musicNotes ?? '');

    if (viewBoxMatch != null) _musicNotesWidth = double.parse(viewBoxMatch.group(1)!);

    _musicNotes = (songLyric.musicNotes ?? '').replaceFirstMapped(_sizeRE, (match) {
      _musicNotesMaxWidth = double.parse(match.group(1)!);

      return 'viewBox="0 0 ${viewBoxMatch!.group(1)!} ${viewBoxMatch.group(2)!}"';
    }).replaceAll('Times,serif', 'Times New Roman');

    print(musicNotesWidth);
    print(musicNotesMaxWidth);

    return _musicNotes!;
  }

  @override
  Future<ByteData> load(String _) async => utf8.encode(musicNotes).buffer.asByteData();
}
