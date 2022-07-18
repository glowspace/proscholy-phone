import 'package:flutter/material.dart';
import 'package:zpevnik/components/home/song_lists_section.dart';
import 'package:zpevnik/components/home/top_section.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchIsOpen = ModalRoute.of(context)?.settings.name == '/search';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 2 * kDefaultPadding),
                const TopSection(),
                if (!searchIsOpen) const SizedBox(height: 2 * kDefaultPadding),
                if (!searchIsOpen) const SearchField(key: Key('searchfield')),
                const SizedBox(height: 2 * kDefaultPadding),
                const SongListsSection(),
                const SizedBox(height: 2 * kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
