import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/home/top_section.dart';
import 'package:zpevnik/components/menu/home/playlists_list_view.dart';
import 'package:zpevnik/components/search_field.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSearch = context.select<NavigationProvider, bool>((provider) => provider.isSearch);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 2 * kDefaultPadding),
                    const TopSection(),
                    AnimatedCrossFade(
                      crossFadeState: isSearch ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: kDefaultAnimationDuration,
                      firstChild: Container(
                        margin: const EdgeInsets.only(top: 2 * kDefaultPadding),
                        child: const SearchField(key: Key('searchfield')),
                      ),
                      secondChild: Container(),
                    ),
                    const SizedBox(height: 2 * kDefaultPadding),
                    Text('Moje seznamy', style: Theme.of(context).textTheme.titleLarge),
                    const Expanded(child: PlaylistsListView()),
                    const SizedBox(height: 2 * kDefaultPadding),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
            Highlightable(
              onTap: () => NavigationProvider.of(context).pushNamed('/user'),
              padding: const EdgeInsets.all(1.5 * kDefaultPadding),
              child: const Icon(Icons.settings, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
