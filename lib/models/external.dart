import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/utils/beans.dart';

class External {
  @PrimaryKey()
  final int id;

  final String name;
  final String mediaId;

  @BelongsTo(SongLyricBean)
  int songLyricId;

  External({
    this.id,
    this.name,
    this.mediaId,
  });
}
