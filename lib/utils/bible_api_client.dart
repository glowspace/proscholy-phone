import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/bible_verse.dart';

part 'bible_api_client.g.dart';

final _bibleApiUrl = Uri.https('api.getbible.net');

@Riverpod(keepAlive: true)
Future<List<dynamic>> bibleVerses(BibleVersesRef ref, BibleTranslation translation, BibleBook book, int chapter) async {
  final response = await http.get(_bibleApiUrl.resolve('v2/${translation.abbreviation}/${book.number}/$chapter.json'));

  final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

  return decodedResponse['verses'] as List<dynamic>;
}

@riverpod
Future<String> bibleVerse(
  BibleVerseRef ref,
  BibleTranslation translation,
  BibleBook book,
  int chapter,
  int startVerse, {
  int? endVerse,
}) async {
  final verses = await ref.read(bibleVersesProvider(translation, book, chapter).future);

  if (endVerse == null) return verses[startVerse - 1]['text'];

  return verses.sublist(startVerse - 1, endVerse).map((verse) => verse['text']).join(' ');
}
