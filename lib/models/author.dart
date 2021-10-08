import 'package:zpevnik/models/model.dart' as model;

// wrapper around Author db model for easier field access
class Author {
  final model.Author entity;

  Author(this.entity);

  static Future<List<Author>> get authors async {
    final entities = await model.Author().select().toList();

    return entities.map((entity) => Author(entity)).toList();
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
}
