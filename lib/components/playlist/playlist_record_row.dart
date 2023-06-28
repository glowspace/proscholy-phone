import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/utils/bible_api_client.dart';

class PlaylistRecordRow extends StatelessWidget {
  final PlaylistRecord playlistRecord;

  const PlaylistRecordRow({super.key, required this.playlistRecord});

  @override
  Widget build(BuildContext context) {
    final songLyric = playlistRecord.songLyric.target;

    if (songLyric != null) return SongLyricRow(songLyric: songLyric, isReorderable: true);

    final bibleVerse = playlistRecord.bibleVerse.target;
    final customText = playlistRecord.customText.target;

    final String title;
    final IconData icon;
    if (bibleVerse != null) {
      title = bibleVerse.endVerse == null
          ? '${supportedBibleBooks[bibleVerse.book]} ${bibleVerse.startVerse}'
          : '${supportedBibleBooks[bibleVerse.book]} ${bibleVerse.startVerse}:${bibleVerse.endVerse}';
      icon = Icons.book_outlined;
    } else if (customText != null) {
      title = customText.name;
      icon = Icons.edit_note;
    } else {
      throw UnimplementedError('unsupported playlist record');
    }

    return InkWell(
      onTap: () => _pushPlaylistRecord(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: Row(children: [
          const ReorderableDragStartListener(
            index: 0,
            child: Padding(
              padding: EdgeInsets.only(left: kDefaultPadding, right: 2 * kDefaultPadding),
              child: Icon(Icons.drag_indicator),
            ),
          ),
          Expanded(child: Text(title)),
          Icon(icon),
        ]),
      ),
    );
  }

  void _pushPlaylistRecord(BuildContext context) {
    final bibleVerse = playlistRecord.bibleVerse.target;

    if (bibleVerse != null) {
      context.push('/playlist/bible_verse', extra: bibleVerse);
      return;
    }

    context.push('/playlist/custom_text', extra: playlistRecord.customText.target);
  }
}
