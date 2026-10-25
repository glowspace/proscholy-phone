import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';

part 'generated/author.freezed.dart';
part 'generated/author.g.dart';

@freezed
sealed class Author extends Model with _$Author {
  const Author._();

  static const String fieldKey = 'authors';

  @Entity(realClass: Author)
  const factory Author({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
}
