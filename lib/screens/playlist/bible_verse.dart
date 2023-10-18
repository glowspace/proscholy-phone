import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/routing/router.dart';
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

  late bool _isEditing = widget.bibleVerse == null;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) => CustomScaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: Text(_endVerse == null ? '$_bibleBook $_startVerse' : '$_bibleBook $_startVerse:$_endVerse'),
          actions: [
            Highlightable(
              onTap: () => _editOrPop(context, ref),
              padding: const EdgeInsets.symmetric(vertical: 1.5 * kDefaultPadding),
              icon: _isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isEditing) ...[
                    _buildMenu(
                      context,
                      title: 'Překlad',
                      initialSelection: _bibleTranslation,
                      dropdownMenuEntries: [
                        for (final translation in supportedBibleTranslations)
                          DropdownMenuEntry(value: translation, label: translation.name)
                      ],
                      onSelected: (value) => setState(() => _bibleTranslation = value!),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    _buildMenu(
                      context,
                      title: 'Kniha',
                      initialSelection: _bibleBook,
                      dropdownMenuEntries: [
                        for (final book in supportedBibleBooks) DropdownMenuEntry(value: book, label: book.name)
                      ],
                      onSelected: (value) => setState(() => _bibleBook = value),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    if (_bibleBook != null)
                      _buildMenu(
                        context,
                        title: 'Kapitola',
                        initialSelection: _chapter - 1,
                        dropdownMenuEntries: [
                          for (int i = 0; i < _bibleBook!.verseCounts.length; i++)
                            DropdownMenuEntry(value: i, label: '${i + 1}')
                        ],
                        onSelected: (value) => setState(() => _chapter = value! + 1),
                      ),
                    const SizedBox(height: kDefaultPadding),
                    if (_bibleBook != null)
                      _buildMenu(
                        context,
                        title: 'Číslo verše',
                        initialSelection: _startVerse - 1,
                        dropdownMenuEntries: [
                          for (int i = 0; i < (_endVerse ?? _bibleBook!.verseCounts[_chapter - 1]); i++)
                            DropdownMenuEntry(value: i, label: '${i + 1}')
                        ],
                        onSelected: (value) => setState(() => _startVerse = value! + 1),
                      ),
                    const SizedBox(height: kDefaultPadding),
                    if (_bibleBook != null)
                      _buildMenu(
                        context,
                        title: 'Konečný verš',
                        initialSelection: _endVerse == null ? null : _endVerse! - 1,
                        dropdownMenuEntries: [
                          for (int i = _startVerse - 1; i < _bibleBook!.verseCounts[_chapter - 1]; i++)
                            DropdownMenuEntry(value: i, label: '${i + 1}')
                        ],
                        onSelected: (value) =>
                            setState(() => _endVerse = (value == null || value + 1 == _startVerse) ? null : value + 1),
                      ),
                    const SizedBox(height: kDefaultPadding),
                  ],
                  if (_bibleBook != null)
                    ref
                        .watch(bibleVerseProvider(_bibleTranslation, _bibleBook!, _chapter, _startVerse,
                            endVerse: _endVerse))
                        .when(
                          data: (verse) => Text(verse),
                          loading: () => const CircularProgressIndicator.adaptive(),
                          error: (_, __) => const SizedBox(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenu<T> _buildMenu<T>(
    BuildContext context, {
    String title = '',
    T? initialSelection,
    List<DropdownMenuEntry<T>> dropdownMenuEntries = const [],
    Function(T?)? onSelected,
  }) {
    return DropdownMenu<T>(
      menuHeight: 0.75 * MediaQuery.of(context).size.height,
      menuStyle: const MenuStyle(visualDensity: VisualDensity.compact),
      label: Text(title),
      initialSelection: initialSelection,
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: onSelected,
    );
  }

  void _editOrPop(BuildContext context, WidgetRef ref) async {
    if (!_isEditing) {
      setState(() => _isEditing = true);
      return;
    }

    if (widget.bibleVerse == null) {
      context.pop((
        book: _bibleBook!.number - 1,
        chapter: _chapter,
        startVerse: _startVerse,
        endVerse: _endVerse,
        text: await ref.read(
            bibleVerseProvider(_bibleTranslation, _bibleBook!, _chapter, _startVerse, endVerse: _endVerse).future),
      ));
    } else {
      setState(() => _isEditing = false);
    }
  }
}
