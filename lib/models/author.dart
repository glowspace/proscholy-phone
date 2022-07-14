import 'package:objectbox/objectbox.dart';

@Entity()
class Author {
  @Id(assignable: true)
  final int id;

  final String name;

  Author(this.id, this.name);

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      int.parse(json['id'] as String),
      json['name'] as String,
    );
  }

  static List<Author> fromMapList(Map<String, dynamic> json) {
    return (json['authors'] as List).map((json) => Author.fromJson(json)).toList();
  }

  @override
  String toString() => 'Author(id: $id, name: $name)';
}
