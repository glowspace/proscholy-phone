import 'package:jaguar_orm/jaguar_orm.dart';

import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';

part 'beans.jorm.dart';

@GenBean()
class SongLyricBean extends Bean<SongLyric> with _SongLyricBean {
  SongBean songBean;
  SongbookBean songbookBean;
  AuthorBean authorBean;
  TagBean tagBean;
  ExternalBean externalBean;
  PlaylistBean playlistBean;

  SongLyricSongBean songLyricSongBean;
  SongbookRecordBean songbookRecordBean;
  SongLyricAuthorBean songLyricAuthorBean;
  SongLyricPlaylistBean songLyricPlaylistBean;

  SongLyricBean(Adapter adapter)
      : songBean = SongBean(adapter),
        songbookBean = SongbookBean(adapter),
        authorBean = AuthorBean(adapter),
        tagBean = TagBean(adapter),
        externalBean = ExternalBean(adapter),
        playlistBean = PlaylistBean(adapter),
        songLyricSongBean = SongLyricSongBean(adapter),
        songbookRecordBean = SongbookRecordBean(adapter),
        songLyricAuthorBean = SongLyricAuthorBean(adapter),
        songLyricPlaylistBean = SongLyricPlaylistBean(adapter),
        super(adapter);

  @override
  String get tableName => 'song_lyrics';
}

@GenBean()
class SongBean extends Bean<Song> with _SongBean {
  SongLyricBean songLyricBean;

  SongLyricSongBean songLyricSongBean;

  SongBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songLyricSongBean = SongLyricSongBean(adapter),
        super(adapter);

  @override
  String get tableName => 'songs';
}

@GenBean()
class SongbookBean extends Bean<Songbook> with _SongbookBean {
  SongLyricBean songLyricBean;

  SongbookRecordBean songbookRecordBean;

  SongbookBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songbookRecordBean = SongbookRecordBean(adapter),
        super(adapter);

  @override
  String get tableName => 'songbooks';
}

@GenBean()
class AuthorBean extends Bean<Author> with _AuthorBean {
  SongLyricBean songLyricBean;

  SongLyricAuthorBean songLyricAuthorBean;

  AuthorBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songLyricAuthorBean = SongLyricAuthorBean(adapter),
        super(adapter);

  @override
  String get tableName => 'authors';
}

@GenBean()
class TagBean extends Bean<Tag> with _TagBean {
  SongLyricBean songLyricBean;

  TagBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        super(adapter);

  @override
  String get tableName => 'tags';
}

@GenBean()
class ExternalBean extends Bean<External> with _ExternalBean {
  SongLyricBean songLyricBean;

  ExternalBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        super(adapter);

  @override
  String get tableName => 'externals';
}

@GenBean()
class PlaylistBean extends Bean<Playlist> with _PlaylistBean {
  SongLyricBean songLyricBean;

  SongLyricPlaylistBean songLyricPlaylistBean;

  PlaylistBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songLyricPlaylistBean = SongLyricPlaylistBean(adapter),
        super(adapter);

  @override
  String get tableName => 'playlists';
}

class SongLyricSong {
  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(SongBean)
  int songId;
}

@GenBean()
class SongLyricSongBean extends Bean<SongLyricSong> with _SongLyricSongBean {
  SongLyricBean songLyricBean;
  SongBean songBean;

  SongLyricSongBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songBean = SongBean(adapter),
        super(adapter);

  @override
  String get tableName => 'song_lyrics_songs';
}

class SongbookRecord {
  final String number;

  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(SongbookBean)
  int songbookId;

  SongbookRecord({this.number});
}

@GenBean()
class SongbookRecordBean extends Bean<SongbookRecord> with _SongbookRecordBean {
  SongLyricBean songLyricBean;
  SongbookBean songbookBean;

  SongbookRecordBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        songbookBean = SongbookBean(adapter),
        super(adapter);

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
class SongLyricAuthorBean extends Bean<SongLyricAuthor>
    with _SongLyricAuthorBean {
  SongLyricBean songLyricBean;
  AuthorBean authorBean;

  SongLyricAuthorBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        authorBean = AuthorBean(adapter),
        super(adapter);

  @override
  String get tableName => 'song_lyrics_authors';
}

class SongLyricPlaylist {
  @BelongsTo.many(SongLyricBean)
  int songLyricId;

  @BelongsTo.many(PlaylistBean)
  int playlistId;
}

@GenBean()
class SongLyricPlaylistBean extends Bean<SongLyricPlaylist>
    with _SongLyricPlaylistBean {
  SongLyricBean songLyricBean;
  PlaylistBean playlistBean;

  SongLyricPlaylistBean(Adapter adapter)
      : songLyricBean = SongLyricBean(adapter),
        playlistBean = PlaylistBean(adapter),
        super(adapter);

  @override
  String get tableName => 'song_lyrics_authors';
}
