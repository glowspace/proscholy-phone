import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@Freezed(toJson: false, equal: false)
class Author with _$Author implements Identifiable {
  const Author._();

  static const String fieldKey = 'authors';

  @Entity(realClass: Author)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory Author({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Author && id == other.id;
}
