import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_navigation_bar.dart';
import 'package:zpevnik/components/custom/back_button.dart';
import 'package:zpevnik/components/playlist/playlists_list_view.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Moje seznamy', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        child: const Icon(Icons.add),
        onPressed: () => showPlaylistDialog(context),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: const SafeArea(child: PlaylistsListView()),
    );
  }
}
