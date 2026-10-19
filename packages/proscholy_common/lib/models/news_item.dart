import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';

part 'generated/news_item.freezed.dart';
part 'generated/news_item.g.dart';

@freezed
sealed class NewsItem extends Model with _$NewsItem {
  const NewsItem._();

  @Entity(realClass: NewsItem)
  const factory NewsItem({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String text,
    required String link,
    @Property(type: PropertyType.date) DateTime? expiresAt,
  }) = _NewsItem;

  factory NewsItem.fromJson(Map<String, Object?> json) => _$NewsItemFromJson(json);
}
