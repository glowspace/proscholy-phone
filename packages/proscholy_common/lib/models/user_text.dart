import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';

part 'generated/user_text.freezed.dart';

@freezed
sealed class UserText with _$UserText implements DisplayableItem, Identifiable, RecentItem {
  const UserText._();

  @Entity(realClass: UserText)
  const factory UserText({
    // 0 until it is stored
    @Id(assignable: true) @Default(0) int id,
    required String name,
    required String content,
  }) = _UserText;

  @override
  String get displayName => name;

  @override
  RecentItemType get recentItemType => RecentItemType.userText;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is UserText && id == other.id && name == other.name;
}
