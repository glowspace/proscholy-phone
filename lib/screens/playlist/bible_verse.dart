import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/utils/bible_api_client.dart';

class BibleVerseScreen extends StatefulWidget {
  final BibleVerse? bibleVerse;

  const BibleVerseScreen({super.key, this.bibleVerse});

  @override
  State<BibleVerseScreen> createState() => _BibleVerseScreenState();
}

class _BibleVerseScreenState extends State<BibleVerseScreen> {
  BibleTranslation _bibleTranslation = supportedBibleTranslations.first;
  late BibleBook? _bibleBook = widget.bibleVerse == null ? null : supportedBibleBooks[widget.bibleVerse!.book];
  late int _chapter = widget.bibleVerse?.chapter ?? 1;
  late int _startVerse = widget.bibleVerse?.startVerse ?? 1;
  late int? _endVerse = widget.bibleVerse?.endVerse;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) => CustomScaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          actions: [
            Highlightable(
              onTap: () async => context.pop((
                book: _bibleBook!.number - 1,
                chapter: _chapter,
                startVerse: _startVerse,
                endVerse: _endVerse,
                text: await ref.read(
                    bibleVerseProvider(_bibleTranslation, _bibleBook!, _chapter, _startVerse, endVerse: _endVerse)
                        .future),
              )),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              DropdownButton<BibleTranslation>(
                value: _bibleTranslation,
                items: [
                  for (final translation in supportedBibleTranslations)
                    DropdownMenuItem(value: translation, child: Text(translation.name))
                ],
                onChanged: (value) => setState(() => _bibleTranslation = value!),
              ),
              DropdownButton<BibleBook>(
                value: _bibleBook,
                items: [for (final book in supportedBibleBooks) DropdownMenuItem(value: book, child: Text(book.name))],
                onChanged: (value) => setState(() => _bibleBook = value),
              ),
              if (_bibleBook != null)
                DropdownButton<int>(
                  value: _chapter - 1,
                  items: [
                    for (int i = 0; i < _bibleBook!.verseCounts.length; i++)
                      DropdownMenuItem(value: i, child: Text('${i + 1}'))
                  ],
                  onChanged: (value) => setState(() => _chapter = value! + 1),
                ),
              if (_bibleBook != null)
                DropdownButton<int>(
                  value: _startVerse - 1,
                  items: [
                    for (int i = 0; i < (_endVerse ?? _bibleBook!.verseCounts[_chapter - 1]); i++)
                      DropdownMenuItem(value: i, child: Text('${i + 1}'))
                  ],
                  onChanged: (value) => setState(() => _startVerse = value! + 1),
                ),
              if (_bibleBook != null)
                DropdownButton<int>(
                  value: _endVerse == null ? null : _endVerse! - 1,
                  items: [
                    for (int i = _startVerse - 1; i < _bibleBook!.verseCounts[_chapter - 1]; i++)
                      DropdownMenuItem(value: i, child: Text('${i + 1}'))
                  ],
                  onChanged: (value) => setState(() => _endVerse = value == null ? null : value + 1),
                ),
              if (_bibleBook != null)
                ref
                    .watch(
                        bibleVerseProvider(_bibleTranslation, _bibleBook!, _chapter, _startVerse, endVerse: _endVerse))
                    .when(
                      data: (verse) => Text(verse),
                      loading: () => const CircularProgressIndicator.adaptive(),
                      error: (_, __) => const SizedBox(),
                    ),
            ]),
          ),
        ),
      ),
    );
  }
}
