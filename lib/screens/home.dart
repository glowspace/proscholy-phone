import 'package:flutter/material.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';

const double _avatarSize = 19;

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
            _buildTopSection(context),
            const SizedBox(height: 2 * kDefaultPadding),
            _buildNewsSection(context),
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

  Widget _buildNewsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Section(
      title: 'Dobré ráno',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: yellow),
              const SizedBox(width: kDefaultPadding),
              Text('Novinky', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          Text('Letní Convivum na Velehradě', style: textTheme.bodyMedium),
        ],
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
