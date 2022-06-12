import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/home/news_section.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

const double _avatarSize = 19;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dataProvider = context.read<DataProvider>();

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
            if (dataProvider.isUpdating) _buildUpdateSection(context),
            if (dataProvider.isUpdating) const SizedBox(height: 2 * kDefaultPadding),
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
        Image.asset('assets/images/title.png', height: 2 * _avatarSize),
        const Spacer(),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/logos/apple_dark.png'),
          radius: _avatarSize,
        ),
      ],
    );
  }

  Widget _buildUpdateSection(BuildContext context) {
    final dataProvider = context.read<DataProvider>();

    return Section(
      child: ValueListenableBuilder<int>(
        valueListenable: dataProvider.updateProgress,
        builder: (_, value, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Probíhá stahování písní ($value/${dataProvider.updatingSongLyricsCount})'),
            const SizedBox(height: kDefaultPadding / 2),
            LinearProgressIndicator(value: value / dataProvider.updatingSongLyricsCount)
          ],
        ),
      ),
    );
  }

  Widget _buildSongListsSection(BuildContext context) {
    return Section(
      title: 'Moje seznamy',
      child: Row(
        children: [],
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
