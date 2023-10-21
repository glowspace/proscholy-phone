import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/utils/extensions.dart';

class BibleVerseScreen extends StatefulWidget {
  final BibleVerse bibleVerse;

  const BibleVerseScreen({super.key, required this.bibleVerse});

  @override
  State<BibleVerseScreen> createState() => _BibleVerseScreenState();
}

class _BibleVerseScreenState extends State<BibleVerseScreen> {
  late BibleVerse _bibleVerse = widget.bibleVerse;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(_bibleVerse.name),
        actions: [
          Highlightable(
            onTap: _edit,
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      hideNavigationRail: context.isPlaylist,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                2 * kDefaultPadding,
                kDefaultPadding,
                2 * kDefaultPadding,
                MediaQuery.paddingOf(context).bottom + kDefaultPadding,
              ),
              child: Text(_bibleVerse.text)),
        ),
      ),
    );
  }

  void _edit() async {
    final bibleVerse =
        (await context.push('/playlist/bible_verse/select_verse', arguments: _bibleVerse)) as BibleVerse?;

    if (bibleVerse != null) setState(() => _bibleVerse = bibleVerse);
  }
}
