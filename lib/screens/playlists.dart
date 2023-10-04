import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/menu_collapsed.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet) return const _PlaylistScreenTablet();

    return CustomScaffold(
      appBar: AppBar(leading: const CustomBackButton(), title: const Text('Moje seznamy')),
      floatingActionButton: Consumer(
        builder: (context, ref, __) => FloatingActionButton(
          backgroundColor: Theme.of(context).canvasColor,
          child: const Icon(Icons.add),
          onPressed: () => showPlaylistDialog(context, ref),
        ),
      ),
      body: const SafeArea(child: PlaylistsListView()),
    );
  }
}

class _PlaylistScreenTablet extends ConsumerStatefulWidget {
  const _PlaylistScreenTablet();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScreenTabletState();
}

class _PlaylistScreenTabletState extends ConsumerState<_PlaylistScreenTablet> {
  late ValueNotifier<Playlist> _selectedPlaylist;

  @override
  void initState() {
    super.initState();

    _selectedPlaylist = ValueNotifier(ref.read(favoritePlaylistProvider));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedPlaylist,
      builder: (_, selectedPlaylist, ___) {
        if (ref.watch(menuCollapsedProvider)) return PlaylistScreen(playlist: selectedPlaylist);

        return SplitView(
          childFlex: 3,
          subChildFlex: 7,
          subChild: PlaylistScreen(playlist: selectedPlaylist, isInsideSplitView: true),
          child: CustomScaffold(
            appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Moje seznamy')),
            floatingActionButton: Consumer(
              builder: (context, ref, __) => FloatingActionButton(
                backgroundColor: Theme.of(context).canvasColor,
                child: const Icon(Icons.add),
                onPressed: () => showPlaylistDialog(context, ref),
              ),
            ),
            body: SafeArea(child: PlaylistsListView(selectedPlaylist: _selectedPlaylist)),
          ),
        );
      },
    );
  }
}
