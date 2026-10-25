import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/bible_passage.dart';

part 'bible_api_client.g.dart';

final _bibleApiUrl = Uri.https('api.getbible.net');

// TODO: make this work without riverpod

@riverpod
Future<List<dynamic>> biblePassages(Ref ref, BibleTranslation translation, BibleBook book, int chapter) async {
  final url = _bibleApiUrl.resolve('v2/${translation.abbreviation}/${book.number}/$chapter.json');
  final response = await http.get(url);

  if (response.statusCode != 200) throw http.ClientException('Bible API responded with ${response.statusCode}', url);

  final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

  // only verses that were loaded are kept, failed requests are made again next time
  ref.keepAlive();

  return decodedResponse['verses'] as List<dynamic>;
}

@riverpod
Future<String> biblePassage(
  Ref ref,
  BibleTranslation translation,
  BibleBook book,
  int chapter,
  int startVerse, {
  int? endVerse,
}) async {
  final verses = await ref.watch(biblePassagesProvider(translation, book, chapter).future);

  if (endVerse == null) return verses[startVerse - 1]['text'];

  return verses.sublist(startVerse - 1, endVerse).map((verse) => verse['text'].trim()).join(' ');
}
