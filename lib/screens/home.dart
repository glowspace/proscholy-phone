import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_navigation_bar.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/home/shared_with_me_section.dart';
import 'package:zpevnik/components/home/song_lists_section.dart';
import 'package:zpevnik/components/home/songbooks_section.dart';
import 'package:zpevnik/components/home/top_section.dart';
import 'package:zpevnik/components/home/update_section.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text;
    final now = DateTime.now();

    if (now.hour < 11) {
      text = 'Dobré ráno';
    } else if (now.hour < 12) {
      text = 'Dobré dopoledne';
    } else if (now.hour < 18) {
      text = 'Dobré odpoledne';
    } else {
      text = 'Dobrý večer';
    }

    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth > kTabletWidthBreakpoint) {
        return _HomeScreenTablet(greetings: text);
      } else {
        return _HomeScreenPhone(greetings: text);
      }
    });
  }
}

class _HomeScreenPhone extends StatelessWidget {
  final String greetings;

  const _HomeScreenPhone({Key? key, required this.greetings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 2 * kDefaultPadding),
                const TopSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                const SearchField(key: Key('searchfield')),
                const SizedBox(height: 2 * kDefaultPadding),
                Text(greetings, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: kDefaultPadding / 2),
                const UpdateSection(),
                const NewsSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                const SongListsSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                const SongbooksSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                // const SharedWithMeSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeScreenTablet extends StatelessWidget {
  final String greetings;

  const _HomeScreenTablet({Key? key, required this.greetings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 2 * kDefaultPadding),
                Text(greetings, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: kDefaultPadding / 2),
                const UpdateSection(),
                const NewsSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                const SongbooksSection(),
                const SizedBox(height: 2 * kDefaultPadding),
                // const SharedWithMeSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
