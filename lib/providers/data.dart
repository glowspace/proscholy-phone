import 'package:flutter/material.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/client.dart';

class DataProvider extends ChangeNotifier {
  late final Store store;

  ValueNotifier<int> updateProgress = ValueNotifier(0);
  int updatingSongLyricsCount = 0;

  bool get isUpdating => updateProgress.value < updatingSongLyricsCount;

  Future<void> init() async {
    store = await openStore();

    update();
  }

  Future<void> update() async {
    final client = Client();

    final data = await client.getData();
    final songLyricIds = data['song_lyrics'].map((json) => int.parse(json['id'])).toList();

    updatingSongLyricsCount = songLyricIds.length;
    updateProgress.value = 1340;

    final List<Future> futures = [];

    // for (final songLyricId in songLyricIds) {
    //   futures.add(client.getSongLyric(songLyricId).then((json) => updateProgress.value += 1));
    // }

    await Future.wait(futures);

    client.dispose();
  }

  List<NewsItem> get newsItems => store
      .box<NewsItem>()
      .query(NewsItem_.expiresAt.greaterOrEqual(DateTime.now().millisecondsSinceEpoch))
      .build()
      .find();

  List<SongLyric> get songLyrics {
    final query = store.box<SongLyric>().query(SongLyric_.lyrics.notNull());

    query.order(SongLyric_.name);

    return query.build().find();
  }

  List<Tag> get tags => store.box<Tag>().getAll();

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}
