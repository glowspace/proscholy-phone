// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';

@Entity()
class NewsItem {
  @Id(assignable: true)
  final int id;

  @Index()
  final String text;
  final String link;

  @Property(type: PropertyType.date)
  final DateTime? expiresAt;

  NewsItem(
    this.id,
    this.text,
    this.link,
    this.expiresAt,
  );

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      int.parse(json['id'] as String),
      json['text'] as String,
      json['link'] as String,
      json['expires_at'] == null ? null : DateTime.parse(json['expires_at'] as String),
    );
  }

  static List<NewsItem> fromMapList(Map<String, dynamic> json) {
    return (json['news_items'] as List).map((json) => NewsItem.fromJson(json)).toList();
  }

  static List<NewsItem> load(Store store, _) {
    return store
        .box<NewsItem>()
        .query(NewsItem_.expiresAt.greaterOrEqual(DateTime.now().millisecondsSinceEpoch))
        .build()
        .find();
  }

  @override
  String toString() => 'NewsItem(id: $id, text: $text, link: $link, expiresAt: $expiresAt)';
}
