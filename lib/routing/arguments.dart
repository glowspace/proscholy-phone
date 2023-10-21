import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class DisplayScreenArguments {
  final List<dynamic> items;
  final int initialIndex;

  const DisplayScreenArguments({required this.items, this.initialIndex = 0});

  factory DisplayScreenArguments.item(dynamic item) => DisplayScreenArguments(items: [item]);
}

@immutable
class SearchScreenArguments {
  final bool shouldReturnSongLyric;

  const SearchScreenArguments({required this.shouldReturnSongLyric});

  factory SearchScreenArguments.returnSongLyric() => const SearchScreenArguments(shouldReturnSongLyric: true);
}
