import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricScreenArguments {
  final List<SongLyric> songLyrics;
  final int index;

  final PageController? pageController;

  SongLyricScreenArguments(this.songLyrics, this.index, {this.pageController});
}
