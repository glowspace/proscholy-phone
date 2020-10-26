import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/beans.dart';

class SongLyric {
  @PrimaryKey()
  final int id;

  final String name;
  final String lyrics;
  final String language;
  final int type;

  @ManyToMany(SongLyricAuthorBean, AuthorBean)
  List<Author> authors;

  @HasMany(ExternalBean)
  List<External> externals;

  @HasMany(TagBean)
  List<Tag> tags;

  @ManyToMany(SongLyricPlaylistBean, PlaylistBean)
  List<Playlist> playlists;

  @ManyToMany(SongbookRecordBean, SongbookBean)
  List<Songbook> songbooks;

  @ManyToMany(SongLyricSongBean, SongBean)
  List<Song> songs;

  SongLyric({
    this.id,
    this.name,
    this.lyrics,
    this.language,
    this.type,
  });
}
