import 'package:zpevnik/models/entities/author.dart';

class Author {
  final AuthorEntity _entity;

  Author(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;
}
