import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/home/update_section.dart';
import 'package:zpevnik/components/playlist/playlist_row.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

const double _avatarRadius = 19;

const _maxShowingPlaylists = 3;

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
            _buildSongListsSection(context),
            const SizedBox(height: 2 * kDefaultPadding),
            _buildSharedWithMeSection(context),
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
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/logos/apple_dark.png'),
          radius: _avatarRadius,
        ),
      ],
    );
  }

  Widget _buildSongListsSection(BuildContext context) {
    final playlists = context.watch<DataProvider>().playlists;

    return Section(
      title: 'Moje seznamy',
      child: ListView.separated(
        itemCount: min(_maxShowingPlaylists, playlists.length),
        itemBuilder: (_, index) => PlaylistRow(playlist: playlists[index]),
        separatorBuilder: (_, __) => const Divider(),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildSharedWithMeSection(BuildContext context) {
    return Section(
      title: 'Sdíleno se mnou',
      child: Row(
        children: [],
      ),
    );
  }
}
