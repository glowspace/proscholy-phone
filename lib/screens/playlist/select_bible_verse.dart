import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/custom/close_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/routing/safe_area_wrapper.dart';
import 'package:zpevnik/utils/bible_api_client.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/url_launcher.dart';

const _failedToLoadVersesMessage = 'Během načítání veršů nastala chyba, zkontrolujte prosím připojení k internetu.';

class SelectBibleVerseScreen extends StatelessWidget {
  final BibleVerse? bibleVerse;

  const SelectBibleVerseScreen({super.key, this.bibleVerse});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => _SelectBibleBookScreen(bibleVerse: bibleVerse)),
    );
  }
}

class _SelectBibleBookScreen extends StatefulWidget {
  final BibleVerse? bibleVerse;

  const _SelectBibleBookScreen({this.bibleVerse});

  @override
  State<_SelectBibleBookScreen> createState() => _SelectBibleBookScreenState();
}

class _SelectBibleBookScreenState extends State<_SelectBibleBookScreen> {
  final initiallyExpandedTileKey = GlobalKey();

  late int? _selectedBook = widget.bibleVerse?.book;
  late int? _selectedChapter = widget.bibleVerse?.chapter;

  @override
  void initState() {
    super.initState();

    // wait for a while, until global key is assigned to widget
    Future.delayed(
      const Duration(milliseconds: 20),
      () {
        if (initiallyExpandedTileKey.currentContext != null) {
          Scrollable.ensureVisible(initiallyExpandedTileKey.currentContext!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomCloseButton(),
          title: const Text('Výběr verše'),
          actions: [
            if (_selectedBook != null)
              Highlightable(
                onTap: () => _forward(context),
                padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                icon: Icon(Theme.of(context).platform.isIos ? Icons.arrow_forward_ios : Icons.arrow_forward),
              ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int index = 0; index < supportedBibleBooks.length; index++)
                  ExpansionTile(
                    key: _selectedBook == index ? initiallyExpandedTileKey : null,
                    shape: const Border(),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                      vertical: kDefaultPadding / 2,
                    ),
                    initiallyExpanded: _selectedBook == index,
                    title: Text(supportedBibleBooks[index].name),
                    children: [
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 96),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: supportedBibleBooks[index].verseCounts.length,
                        itemBuilder: (_, chapterIndex) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.25, color: Theme.of(context).colorScheme.outline),
                          ),
                          margin: const EdgeInsets.all(kDefaultPadding / 2),
                          child: Highlightable(
                            onTap: () {
                              setState(() {
                                _selectedBook = index;
                                _selectedChapter = chapterIndex + 1;
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => _SelectBibleVerseScreen(
                                    book: supportedBibleBooks[index],
                                    chapter: chapterIndex + 1,
                                    bibleVerse: widget.bibleVerse,
                                  ),
                                ),
                              );
                            },
                            highlightBackground: true,
                            child: Ink(
                              color: _selectedBook == index && _selectedChapter == chapterIndex + 1
                                  ? Theme.of(context).colorScheme.secondaryContainer
                                  : null,
                              child: Center(child: Text('${chapterIndex + 1}')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _forward(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _SelectBibleVerseScreen(
          book: supportedBibleBooks[_selectedBook!],
          chapter: _selectedChapter!,
          bibleVerse: widget.bibleVerse,
        ),
      ),
    );
  }
}

class _SelectBibleVerseScreen extends StatefulWidget {
  final BibleVerse? bibleVerse;
  final BibleBook book;
  final int chapter;

  const _SelectBibleVerseScreen({required this.book, required this.chapter, this.bibleVerse});

  @override
  State<_SelectBibleVerseScreen> createState() => _SelectBibleVerseScreenState();
}

class _SelectBibleVerseScreenState extends State<_SelectBibleVerseScreen> {
  late int _startVerse;
  late int? _endVerse;

  int get _versesCount => widget.book.verseCounts[widget.chapter - 1];

  @override
  void initState() {
    super.initState();

    if (widget.bibleVerse != null &&
        supportedBibleBooks[widget.bibleVerse!.book] == widget.book &&
        widget.bibleVerse!.chapter == widget.chapter) {
      _startVerse = widget.bibleVerse!.startVerse;
      _endVerse = widget.bibleVerse!.endVerse;
    } else {
      _startVerse = 1;
      _endVerse = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final infoColorScheme = ColorScheme.fromSeed(seedColor: blue, brightness: theme.brightness);

    final startVerseInvalid = _startVerse < 1 || _startVerse > _versesCount;
    final endVerseInvalid = _endVerse != null && (_endVerse! < 1 || _endVerse! > _versesCount);

    final startVerseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: startVerseInvalid ? Colors.red : theme.dividerColor),
      borderRadius: BorderRadius.circular(kDefaultRadius),
    );

    final endVerseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: endVerseInvalid ? Colors.red : theme.dividerColor),
      borderRadius: BorderRadius.circular(kDefaultRadius),
    );

    final textStyle = theme.textTheme.bodyMedium;
    final highlightedStyle = textStyle?.copyWith(color: theme.colorScheme.primary);
    final boldStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusScope.of(context).unfocus,
      child: SafeAreaWrapper(
        child: Scaffold(
          appBar: AppBar(
            leading: const CustomBackButton(),
            title: const Text('Výběr verše'),
            actions: [
              Highlightable(
                onTap: _pop,
                padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: infoColorScheme.primary),
                    color: infoColorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  margin: const EdgeInsets.fromLTRB(kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(children: [
                    Icon(Icons.info, color: infoColorScheme.onPrimaryContainer),
                    const SizedBox(width: kDefaultPadding),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'Pro biblické verše je využíván ',
                          style: textStyle,
                          children: [
                            TextSpan(text: 'Český ekumenický překlad', style: boldStyle),
                            TextSpan(
                              text: ', který je získáván prostřednictím volně dostupné API od$unbreakableSpace',
                              style: textStyle,
                            ),
                            TextSpan(
                              text: 'getbible.net',
                              style: highlightedStyle,
                              recognizer: TapGestureRecognizer()..onTap = () => launch('https://getbible.net'),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                  child: Text('Zadejte číslo veršů v rozsahu 1-$_versesCount', style: theme.textTheme.bodyLarge),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _startVerse.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() => _startVerse = int.tryParse(value) ?? 1),
                          decoration: InputDecoration(
                            labelText: 'Číslo verše',
                            labelStyle:
                                startVerseInvalid ? theme.textTheme.labelLarge?.copyWith(color: Colors.red) : null,
                            border: startVerseBorder,
                            enabledBorder: startVerseBorder,
                          ),
                        ),
                      ),
                      const SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: TextFormField(
                          initialValue: _endVerse?.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() => _endVerse = int.tryParse(value)),
                          decoration: InputDecoration(
                            labelText: 'Konečný verše',
                            labelStyle:
                                endVerseInvalid ? theme.textTheme.labelLarge?.copyWith(color: Colors.red) : null,
                            border: endVerseBorder,
                            enabledBorder: endVerseBorder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        2 * kDefaultPadding,
                        kDefaultPadding,
                        2 * kDefaultPadding,
                        MediaQuery.paddingOf(context).bottom + kDefaultPadding,
                      ),
                      child: Consumer(
                        builder: (_, ref, __) => ref
                            .watch(bibleVerseProvider(
                              supportedBibleTranslations[1],
                              widget.book,
                              widget.chapter,
                              _startVerse,
                              endVerse: _endVerse,
                            ))
                            .when(
                              data: (verses) => Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(verses),
                                  const SizedBox(height: 3 * kDefaultPadding),
                                  Text(
                                    'Chráněno autorskými právy; Oprávnění k distribuci uděleno společnosti CrossWire',
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              error: (_, __) => const Center(child: Text(_failedToLoadVersesMessage)),
                              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pop() async {
    final text = await context.providers.read(bibleVerseProvider(
      supportedBibleTranslations[1],
      widget.book,
      widget.chapter,
      _startVerse,
      endVerse: _endVerse,
    ).future);

    if (!context.mounted) return;

    final BibleVerse bibleVerse;

    if (widget.bibleVerse == null) {
      bibleVerse = context.providers.read(playlistsProvider.notifier).createBibleVerse(
            book: widget.book.number - 1,
            chapter: widget.chapter,
            startVerse: _startVerse,
            endVerse: _endVerse,
            text: text,
          );
    } else {
      bibleVerse = widget.bibleVerse!.copyWith(
        book: widget.book.number - 1,
        chapter: widget.chapter,
        startVerse: _startVerse,
        endVerse: _endVerse,
        text: text,
      );

      context.providers.read(appDependenciesProvider).store.box<BibleVerse>().put(bibleVerse);
    }

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop(bibleVerse);
  }
}
