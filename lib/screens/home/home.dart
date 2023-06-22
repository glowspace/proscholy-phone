import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/bottom_navigation_bar.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/home/additional_section.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/home/recent_section.dart';
import 'package:zpevnik/components/home/shared_with_me_section.dart';
import 'package:zpevnik/components/home/song_lists_section.dart';
import 'package:zpevnik/components/home/songbooks_section.dart';
import 'package:zpevnik/components/home/top_section.dart';
import 'package:zpevnik/components/home/update_section.dart';
import 'package:zpevnik/components/search/search_field.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/home.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _minColumnWidth = 400;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String greetings;
    final now = DateTime.now();

    if (now.hour < 11) {
      greetings = 'Dobré ráno';
    } else if (now.hour < 12) {
      greetings = 'Dobré dopoledne';
    } else if (now.hour < 18) {
      greetings = 'Dobré odpoledne';
    } else {
      greetings = 'Dobrý večer';
    }

    final sections = [
      for (final homeSection in ref.watch(homeSectionSettingsProvider))
        switch (homeSection) {
          HomeSection.news => const NewsSection(),
          HomeSection.recent => const RecentSection(),
          HomeSection.playlists => const SongListsSection(),
          HomeSection.sharedWithMe => const SharedWithMeSection(),
          HomeSection.group => const NewsSection(),
          HomeSection.shared => const NewsSection(),
          HomeSection.songbooks => const SongbooksSection(),
        },
      const AdditionalSection(),
    ];

    final columns = max(1, (MediaQuery.of(context).size.width / _minColumnWidth).floor());
    final sectionsPerColumn = (sections.length / columns).ceil();
    final columnSections = [
      for (int i = 0; i < columns; i++)
        sections.sublist(i * sectionsPerColumn, min((i + 1) * sectionsPerColumn, sections.length))
    ];

    columnSections.first = [
      const TopSection(),
      const SearchField(key: Key('searchfield')),
      Text(greetings, style: Theme.of(context).textTheme.titleLarge),
      const UpdateSection(),
      ...columnSections.first
    ];

    columnSections.last.add(
      HighlightableTextButton(
        padding: const EdgeInsets.only(top: 2 / 3 * kDefaultPadding, bottom: 2 * kDefaultPadding),
        onTap: () => context.push('/edit_sections'),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.edit, size: kDefaultIconSize),
            SizedBox(width: kDefaultPadding / 2),
            Text('Upravit nástěnku')
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).brightness.isLight ? lightBackgroundColor : darkBackgroundColor,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final columnSection in columnSections)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: columnSection,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
