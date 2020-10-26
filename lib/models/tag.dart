import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/utils/beans.dart';

class Tag {
  @PrimaryKey()
  final int id;
  final String name;
  final int type;

  @BelongsTo(SongLyricBean)
  int songLyricId;

  Tag({
    this.id,
    this.name,
    this.type,
  });
}
