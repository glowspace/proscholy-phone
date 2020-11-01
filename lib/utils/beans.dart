import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/author.dart';
import 'package:zpevnik/models/entities/external.dart';
import 'package:zpevnik/models/entities/playlist.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/models/entities/tag.dart';

part 'beans.jorm.dart';

@GenBean()
class SongLyricBean extends Bean<SongLyricEntity> with _SongLyricBean {
  SongBean _songBean;
  AuthorBean _authorBean;
  TagBean _tagEntityBean;
  ExternalBean _externalBean;
  PlaylistBean _playlistBean;

  SongbookRecordBean _songbookRecordBean;
  SongLyricAuthorBean _songLyricAuthorBean;
  SongLyricTagBean _songLyricTagBean;
  SongLyricPlaylistBean _songLyricPlaylistBean;

  SongLyricBean(Adapter adapter) : super(adapter);

  SongBean get songBean => _songBean ??= SongBean(adapter);
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);
  TagBean get tagEntityBean => _tagEntityBean ??= TagBean(adapter);
  ExternalBean get externalBean => _externalBean ??= ExternalBean(adapter);
  PlaylistBean get playlistBean => _playlistBean ??= PlaylistBean(adapter);

  SongbookRecordBean get songbookRecordBean => _songbookRecordBean ??= SongbookRecordBean(adapter);
  SongLyricAuthorBean get songLyricAuthorBean => _songLyricAuthorBean ??= SongLyricAuthorBean(adapter);
  SongLyricTagBean get songLyricTagBean => _songLyricTagBean ??= SongLyricTagBean(adapter);
  SongLyricPlaylistBean get songLyricPlaylistBean => _songLyricPlaylistBean ??= SongLyricPlaylistBean(adapter);

  @override
  String get tableName => 'song_lyrics';
}

@GenBean()
class SongBean extends Bean<Song> with _SongBean {
  SongLyricBean _songLyricEntityBean;

  SongBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);

  @override
  String get tableName => 'songs';
}

@GenBean()
class SongbookBean extends Bean<SongbookEntity> with _SongbookBean {
  SongbookRecordBean _songbookRecordBean;

  SongbookBean(Adapter adapter) : super(adapter);

  SongbookRecordBean get songbookRecordBean => _songbookRecordBean ??= SongbookRecordBean(adapter);

  @override
  String get tableName => 'songbooks';
}

@GenBean()
class AuthorBean extends Bean<Author> with _AuthorBean {
  SongLyricBean _songLyricEntityBean;
  ExternalBean _externalBean;

  SongLyricAuthorBean _songLyricAuthorBean;
  AuthorExternalBean _authorExternalBean;

  AuthorBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  ExternalBean get externalBean => _externalBean ??= ExternalBean(adapter);

  SongLyricAuthorBean get songLyricAuthorBean => _songLyricAuthorBean ??= SongLyricAuthorBean(adapter);
  AuthorExternalBean get authorExternalBean => _authorExternalBean ??= AuthorExternalBean(adapter);

  @override
  String get tableName => 'authors';
}

@GenBean()
class TagBean extends Bean<TagEntity> with _TagBean {
  SongLyricBean _songLyricEntityBean;
  SongLyricTagBean _songLyricTagBean;

  TagBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);

  SongLyricTagBean get songLyricTagBean => _songLyricTagBean ??= SongLyricTagBean(adapter);

  @override
  String get tableName => 'tags';
}

@GenBean()
class ExternalBean extends Bean<External> with _ExternalBean {
  SongLyricBean _songLyricEntityBean;
  AuthorBean _authorBean;

  AuthorExternalBean _authorExternalBean;

  ExternalBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);

  AuthorExternalBean get authorExternalBean => _authorExternalBean ??= AuthorExternalBean(adapter);

  @override
  String get tableName => 'externals';
}

@GenBean()
class PlaylistBean extends Bean<Playlist> with _PlaylistBean {
  SongLyricBean _songLyricEntityBean;

  SongLyricPlaylistBean _songLyricPlaylistBean;

  PlaylistBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);

  SongLyricPlaylistBean get songLyricPlaylistBean => _songLyricPlaylistBean ??= SongLyricPlaylistBean(adapter);

  @override
  String get tableName => 'playlists';
}

@GenBean()
class SongbookRecordBean extends Bean<SongbookRecord> with _SongbookRecordBean {
  SongLyricBean _songLyricEntityBean;
  SongbookBean _songbookEntityBean;

  SongbookRecordBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  SongbookBean get songbookEntityBean => _songbookEntityBean ??= SongbookBean(adapter);

  @override
  String get tableName => 'songbook_records';
}

class SongLyricAuthor {
  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(AuthorBean)
  int authorId;
}

@GenBean()
class SongLyricAuthorBean extends Bean<SongLyricAuthor> with _SongLyricAuthorBean {
  SongLyricBean _songLyricEntityBean;
  AuthorBean _authorBean;

  SongLyricAuthorBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);

  @override
  String get tableName => 'song_lyrics_authors';
}

class SongLyricTag {
  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(TagBean)
  int tagId;

  @override
  String toString() {
    return '$songLyricId: $tagId';
  }
}

@GenBean()
class SongLyricTagBean extends Bean<SongLyricTag> with _SongLyricTagBean {
  SongLyricBean _songLyricEntityBean;
  TagBean _tagEntityBean;

  SongLyricTagBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  TagBean get tagEntityBean => _tagEntityBean ??= TagBean(adapter);

  @override
  String get tableName => 'song_lyrics_tags';
}

class SongLyricPlaylist {
  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(PlaylistBean)
  int playlistId;
}

@GenBean()
class SongLyricPlaylistBean extends Bean<SongLyricPlaylist> with _SongLyricPlaylistBean {
  SongLyricBean _songLyricEntityBean;
  PlaylistBean _playlistBean;

  SongLyricPlaylistBean(Adapter adapter) : super(adapter);

  SongLyricBean get songLyricEntityBean => _songLyricEntityBean ??= SongLyricBean(adapter);
  PlaylistBean get playlistBean => _playlistBean ??= PlaylistBean(adapter);

  @override
  String get tableName => 'song_lyrics_playlists';
}

class AuthorExternal {
  @BelongsTo.many(AuthorBean)
  int authorId;

  @BelongsTo.many(ExternalBean)
  int externalId;
}

@GenBean()
class AuthorExternalBean extends Bean<AuthorExternal> with _AuthorExternalBean {
  AuthorBean _authorBean;
  ExternalBean _externalBean;

  AuthorExternalBean(Adapter adapter) : super(adapter);

  ExternalBean get externalBean => _externalBean ??= ExternalBean(adapter);
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);

  @override
  String get tableName => 'authors_externals';
}
