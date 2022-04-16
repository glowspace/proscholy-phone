import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/filters/section.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagsSections = context.watch<SongLyricsProvider>().tagsSections;

    return ListView.builder(
      controller: PrimaryScrollController.of(context),
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      addRepaintBoundaries: false,
      itemCount: tagsSections.length,
      itemBuilder: (context, index) => FiltersSection(
        title: tagsSections[index].title,
        tags: tagsSections[index].tags,
        isLast: index == tagsSections.length - 1,
      ),
    );
  }
}
