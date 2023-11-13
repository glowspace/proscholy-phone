import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/hero_app_bar.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/hero_tags.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: HeroAppBar(
        tag: HeroTags.playlistsAppBar,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: context.isPlaylists ? const CustomBackButton() : null,
          titleSpacing: context.isPlaylists ? null : 2 * kDefaultPadding,
          title: const Text('Moje seznamy'),
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (_, constraints) => constraints.maxWidth > kTabletSizeBreakpoint
            ? FloatingActionButton.extended(
                heroTag: HeroTags.playlistsFAB,
                backgroundColor: Theme.of(context).colorScheme.surface,
                icon: const Icon(Icons.add),
                label: const Text('Vytvořit nový seznam'),
                onPressed: () => showPlaylistDialog(context),
              )
            : FloatingActionButton(
                heroTag: HeroTags.playlistsFAB,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: const Icon(Icons.add),
                onPressed: () => showPlaylistDialog(context),
              ),
      ),
      body: const Hero(
        tag: HeroTags.playlistsList,
        child: SafeArea(
          // must be wrapped in material widget, as there is no material in tree during hero transition
          child: Material(
            color: Colors.transparent,
            child: PlaylistsListView(),
          ),
        ),
      ),
    );
  }
}
