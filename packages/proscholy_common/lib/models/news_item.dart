import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/links.dart';
import 'package:proscholy_common/models/model.dart';

part 'generated/news_item.freezed.dart';
part 'generated/news_item.g.dart';

@Freezed(toJson: false, equal: false)
class NewsItem with _$NewsItem implements Identifiable {
  static const String fieldKey = 'news_items';

  const NewsItem._();

  @Entity(realClass: NewsItem)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory NewsItem({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String text,
    required String link,
    @Property(type: PropertyType.date) DateTime? expiresAt,
  }) = _NewsItem;

  factory NewsItem.fromJson(Map<String, Object?> json) => _$NewsItemFromJson(json);

  bool get hasLink => link.isNotEmpty;
  String get preparedLink => link.startsWith('/') ? 'https://$baseUrl$link' : link;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is NewsItem && id == other.id;
}
