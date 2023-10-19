import 'package:flutter/material.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/utils/extensions.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: context.isPlaylists ? const CustomBackButton() : null,
        titleSpacing: context.isPlaylists ? null : 2 * kDefaultPadding,
        title: const Text('Moje seznamy'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'playlists',
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: const Icon(Icons.add),
        onPressed: () => showPlaylistDialog(context),
      ),
      body: const SafeArea(child: PlaylistsListView()),
    );
  }
}
