import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/providers/utils.dart';

part 'news_items.g.dart';

@riverpod
List<NewsItem> newsItems(NewsItemsRef ref) {
  return queryStore(ref, condition: NewsItem_.expiresAt.greaterOrEqual(DateTime.now().millisecondsSinceEpoch));
}
