import 'package:objectbox/objectbox.dart';

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

  @override
  String toString() => 'NewsItem(id: $id, text: $text, link: $link, expiresAt: $expiresAt)';
}
