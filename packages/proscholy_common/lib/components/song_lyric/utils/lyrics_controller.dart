import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/components/song_lyric/utils/parser.dart';

final _viewBoxRE = RegExp(r'<svg[^>]* viewBox="0 0 ([\d\.]+) ([\d\.]+)"[^>]*>');
final _sizeRE = RegExp(r'width="([\d\.]+)[^"]*" height="([\d\.]+)[^"]*"');

class LyricsController extends AssetBundle {
  final SongLyric songLyric;
  final String svg;
  final SongLyricsParser parser;

  final BuildContext context;

  LyricsController(this.songLyric, this.svg, this.context) : parser = SongLyricsParser(songLyric);

  late final _viewBoxMatch = _viewBoxRE.firstMatch(svg);
  late final _sizeMatch = _sizeRE.firstMatch(svg);

  String get title => songLyric.name;

  bool get hasMusicNotes => svg.isNotEmpty;

  double get musicNotesWidth => double.parse(_viewBoxMatch?.group(1) ?? '0');
  double get musicNotesMaxWidth => double.parse(_sizeMatch?.group(1) ?? '0');

  late final String musicNotes = svg
      .replaceFirst(_sizeRE, 'viewBox="0 0 ${_viewBoxMatch?.group(1)} ${_viewBoxMatch?.group(2)}"')
      .replaceAll('Times,serif', 'Times New Roman');

  @override
  Future<ByteData> load(String _) async => utf8.encode(musicNotes).buffer.asByteData();
}
