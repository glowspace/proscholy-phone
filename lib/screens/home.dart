import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/home/shared_with_me_section.dart';
import 'package:zpevnik/components/home/song_lists_section.dart';
import 'package:zpevnik/components/home/update_section.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';

const double _avatarRadius = 19;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 2 * kDefaultPadding),
            _buildTopSection(context),
            const SizedBox(height: 2 * kDefaultPadding),
            const SearchField(key: Key('searchfield')),
            const SizedBox(height: 2 * kDefaultPadding),
            Text('Dobré ráno', style: textTheme.titleLarge),
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

  Widget _buildTopSection(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/title.png', height: 2 * _avatarRadius),
        const Spacer(),
        Highlightable(
          onTap: () => Navigator.of(context).pushNamed('/user'),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/logos/apple_dark.png'),
            radius: _avatarRadius,
          ),
        ),
      ],
    );
  }
}
