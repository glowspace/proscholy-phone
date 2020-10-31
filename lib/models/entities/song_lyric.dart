import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/utils/beans.dart';

class SongLyricEntity {
  @PrimaryKey()
  final int id;

  final String name;

  @Column(isNullable: true)
  final String lyrics;

  final String language;
  final int type;

  @Column(isNullable: true)
  int favoriteOrder;

  @ManyToMany(SongLyricAuthorBean, AuthorBean)
  List<Author> authors;

  @HasMany(ExternalBean)
  List<External> externals;

  @ManyToMany(SongLyricTagBean, TagBean)
  List<TagEntity> tags;

  @ManyToMany(SongLyricPlaylistBean, PlaylistBean)
  List<Playlist> playlists;

  @HasMany(SongbookRecordBean)
  List<SongbookRecord> songbookRecords;

  @BelongsTo(SongBean, isNullable: true)
  int songId;

  SongLyricEntity({
    this.id,
    this.name,
    this.lyrics,
    this.language,
    this.type,
  });

  factory SongLyricEntity.fromJson(Map<String, dynamic> json) {
    // print(json['song']);

    final id = int.parse(json['id']);
    final songId = json['song'] == null ? null : (json['song'] as Map<String, dynamic>)['id'];

    return SongLyricEntity(
      id: id,
      name: json['name'],
      lyrics: json['lyrics'],
      language: json['lang_string'],
      // todo: handle type
      type: 1,
    )
      ..authors = (json['authors_pivot'] as List<dynamic>).map((json) => Author.fromJson(json['author'])).toList()
      ..externals = (json['externals'] as List<dynamic>).map((json) => External.fromJson(json)).toList()
      ..tags = (json['tags'] as List<dynamic>).map((json) => TagEntity.fromJson(json)).toList()
      ..playlists = []
      ..songbookRecords = (json['songbook_records'] as List<dynamic>)
          .map((json) => SongbookRecord.fromJson(json)..songLyricId = id)
          .toList()
      ..songId = songId == null ? null : int.parse(songId);
  }
}
