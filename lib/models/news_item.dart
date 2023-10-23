import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'news_item.freezed.dart';
part 'news_item.g.dart';

@Freezed(toJson: false)
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
}
