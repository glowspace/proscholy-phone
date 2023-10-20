import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'custom_text.freezed.dart';

@freezed
class CustomText with _$CustomText implements Identifiable, RecentItem {
  const CustomText._();

  @Entity(realClass: CustomText)
  const factory CustomText({
    @Id(assignable: true) required int id,
    required String name,
    required String content,
  }) = _CustomText;

  @override
  RecentItemType get recentItemType => RecentItemType.customText;
}
