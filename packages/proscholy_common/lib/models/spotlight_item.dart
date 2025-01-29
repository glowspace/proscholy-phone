import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/spotlight_item.freezed.dart';
part 'generated/spotlight_item.g.dart';

@freezed
class SpotlightItem with _$SpotlightItem {
  const factory SpotlightItem({
    required String identifier,
    required String title,
    required String description,
  }) = _SpotlightItem;

  factory SpotlightItem.fromJson(Map<String, Object?> json) => _$SpotlightItemFromJson(json);
}
