import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/components/playlist/selected_playlist.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/menu_collapsed.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).isTablet) return const _PlaylistsScaffoldTablet();

    return const _PlaylistsScaffold();
  }
}

class _PlaylistsScaffoldTablet extends ConsumerStatefulWidget {
  const _PlaylistsScaffoldTablet();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistsScaffoldTabletState();
}

class _PlaylistsScaffoldTabletState extends ConsumerState<_PlaylistsScaffoldTablet> {
  late ValueNotifier<Playlist> _selectedPlaylistNotifier;

  @override
  void initState() {
    super.initState();

    _selectedPlaylistNotifier = ValueNotifier(ref.read(favoritePlaylistProvider));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedPlaylistNotifier,
      builder: (_, selectedPlaylist, child) {
        if (ref.watch(menuCollapsedProvider)) return const _PlaylistsScaffold();

        return SplitView(
          childFlex: 3,
          subChildFlex: 7,
          subChild: PlaylistScreen(playlist: selectedPlaylist),
          child: child!,
        );
      },
      child: SelectedPlaylist(
        playlistNotifier: _selectedPlaylistNotifier,
        child: const _PlaylistsScaffold(showBackButton: false),
      ),
    );
  }
}

class _PlaylistsScaffold extends StatelessWidget {
  final bool showBackButton;

  const _PlaylistsScaffold({this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton ? const CustomBackButton() : null,
        titleSpacing: showBackButton ? null : 2 * kDefaultPadding,
        title: const Text('Moje seznamy'),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, __) => FloatingActionButton(
          heroTag: 'playlists',
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: const Icon(Icons.add),
          onPressed: () => showPlaylistDialog(context, ref),
        ),
      ),
      body: const SafeArea(child: PlaylistsListView()),
    );
  }
}
