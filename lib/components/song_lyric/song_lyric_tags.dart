import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tag.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricTags extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricTags({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Text('Štítky', style: Theme.of(context).textTheme.titleLarge),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding).copyWith(bottom: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: kDefaultPadding / 2,
                      runSpacing: kDefaultPadding / 2,
                      children: songLyric.tags.map((tag) => SongLyricTag(tag: tag)).toList(),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Wrap(
                      spacing: kDefaultPadding / 2,
                      runSpacing: kDefaultPadding / 2,
                      children: songLyric.songbookRecords
                          .map((songbookRecord) => SongLyricTag(songbookRecord: songbookRecord))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
