import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/news_item.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/news_items.g.dart';

@riverpod
List<NewsItem> newsItems(NewsItemsRef ref) {
  return queryStore(ref, condition: NewsItem_.expiresAt.greaterOrEqual(DateTime.now().millisecondsSinceEpoch));
}
