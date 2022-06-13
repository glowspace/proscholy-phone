import 'package:flutter/material.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/utils/updater.dart';

class DataProvider extends ChangeNotifier {
  late final Store store;
  late final Updater updater;

  Future<void> init() async {
    store = await openStore();

    updater = Updater(store);
    await updater.loadInitial();
    // updater.update();
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
