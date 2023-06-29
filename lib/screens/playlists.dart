import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/navigation/scaffold.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
