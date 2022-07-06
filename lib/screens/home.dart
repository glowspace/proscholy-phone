import 'package:flutter/material.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/home/shared_with_me_section.dart';
import 'package:zpevnik/components/home/song_lists_section.dart';
import 'package:zpevnik/components/home/top_section.dart';
import 'package:zpevnik/components/home/update_section.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 2 * kDefaultPadding),
            const TopSection(),
            const SizedBox(height: 2 * kDefaultPadding),
            const SearchField(key: Key('searchfield')),
            const SizedBox(height: 2 * kDefaultPadding),
            Text('Dobré ráno', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: kDefaultPadding / 2),
            const UpdateSection(),
            const NewsSection(),
            const SizedBox(height: 2 * kDefaultPadding),
            const SongListsSection(),
            const SizedBox(height: 2 * kDefaultPadding),
            const SharedWithMeSection(),
          ],
        ),
      ),
    );
  }
}
