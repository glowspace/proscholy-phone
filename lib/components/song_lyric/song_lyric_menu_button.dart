import 'package:flutter/material.dart' hide PopupMenuEntry, PopupMenuItem;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zpevnik/components/custom/popup_menu_button.dart';
import 'package:zpevnik/components/icon_item.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/popup_menu.dart';
import 'package:zpevnik/links.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/presentation.dart';
import 'package:zpevnik/routing/router.dart';
import 'package:zpevnik/utils/url_launcher.dart';

enum SongLyricMenuAction {
  present,
  share,
  openInBrowser,
  report,
}

class SongLyricMenuButton extends ConsumerWidget {
  final SongLyric songLyric;

  const SongLyricMenuButton({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPopupMenuButton(
      items: _buildPopupMenuItems(context, ref),
      onSelected: (context, action) => _selectedAction(context, ref, action),
      padding: const EdgeInsets.only(left: kDefaultPadding, right: 2 * kDefaultPadding),
    );
  }

  List<PopupMenuEntry<SongLyricMenuAction>> _buildPopupMenuItems(BuildContext context, WidgetRef ref) {
    return [
      PopupMenuItem(
        value: SongLyricMenuAction.present,
        child: IconItem(
          icon: Icons.cast,
          text: ref.watch(presentationProvider.select((presentationProvider) => presentationProvider.isPresenting))
              ? 'Ukončit promítání'
              : 'Spustit promítání',
        ),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.share,
        child: IconItem(icon: Icons.share, text: 'Sdílet'),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.openInBrowser,
        child: IconItem(icon: Icons.language, text: 'Otevřít na webu'),
      ),
      const PopupMenuItem(
        value: SongLyricMenuAction.report,
        child: IconItem(icon: Icons.warning, text: 'Nahlásit'),
      ),
    ];
  }

  void _selectedAction(BuildContext context, WidgetRef ref, SongLyricMenuAction? action) {
    if (action == null) return;

    final version = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.packageInfo.version));
    final platform = Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'android';

    switch (action) {
      case SongLyricMenuAction.present:
        final presentationNotifier = ref.read(presentationProvider.notifier);

        if (presentationNotifier.isPresenting) {
          presentationNotifier.stop();
        } else {
          context.push('/song_lyric/present', arguments: songLyric);
        }
        break;
      case SongLyricMenuAction.share:
        final box = context.findRenderObject() as RenderBox?;

        Share.share('$songUrl/${songLyric.id}/', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
        break;
      case SongLyricMenuAction.openInBrowser:
        launch(context, '$songUrl/${songLyric.id}/');
        break;
      case SongLyricMenuAction.report:
        launch(context, '$reportSongLyricUrl?customfield_10056=${songLyric.id}+$version+$platform');
        break;
    }
  }
}
