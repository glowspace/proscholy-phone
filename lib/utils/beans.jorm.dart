// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beans.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _SongLyricBean implements Bean<SongLyric> {
  final id = IntField('id');
  final name = StrField('name');
  final lyrics = StrField('lyrics');
  final language = StrField('language');
  final type = IntField('type');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        lyrics.name: lyrics,
        language.name: language,
        type.name: type,
      };
  SongLyric fromMap(Map map) {
    SongLyric model = SongLyric(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      lyrics: adapter.parseValue(map['lyrics']),
      language: adapter.parseValue(map['language']),
      type: adapter.parseValue(map['type']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(SongLyric model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(lyrics.set(model.lyrics));
      ret.add(language.set(model.language));
      ret.add(type.set(model.type));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(lyrics.name)) ret.add(lyrics.set(model.lyrics));
      if (only.contains(language.name)) ret.add(language.set(model.language));
      if (only.contains(type.name)) ret.add(type.set(model.type));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.lyrics != null) {
        ret.add(lyrics.set(model.lyrics));
      }
      if (model.language != null) {
        ret.add(language.set(model.language));
      }
      if (model.type != null) {
        ret.add(type.set(model.type));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(lyrics.name, isNullable: false);
    st.addStr(language.name, isNullable: false);
    st.addInt(type.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyric model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      SongLyric newModel;
      if (model.authors != null) {
        newModel ??= await find(model.id);
        for (final child in model.authors) {
          await authorBean.insert(child, cascade: cascade);
          await songLyricAuthorBean.attach(newModel, child);
        }
      }
      if (model.externals != null) {
        newModel ??= await find(model.id);
        model.externals
            .forEach((x) => externalBean.associateSongLyric(x, newModel));
        for (final child in model.externals) {
          await externalBean.insert(child, cascade: cascade);
        }
      }
      if (model.tags != null) {
        newModel ??= await find(model.id);
        model.tags.forEach((x) => tagBean.associateSongLyric(x, newModel));
        for (final child in model.tags) {
          await tagBean.insert(child, cascade: cascade);
        }
      }
      if (model.playlists != null) {
        newModel ??= await find(model.id);
        for (final child in model.playlists) {
          await playlistBean.insert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(newModel, child);
        }
      }
      if (model.songbooks != null) {
        newModel ??= await find(model.id);
        for (final child in model.songbooks) {
          await songbookBean.insert(child, cascade: cascade);
          await songbookRecordBean.attach(child, newModel);
        }
      }
      if (model.songs != null) {
        newModel ??= await find(model.id);
        for (final child in model.songs) {
          await songBean.insert(child, cascade: cascade);
          await songLyricSongBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<SongLyric> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(SongLyric model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    var retId;
    if (isForeignKeyEnabled) {
      final Insert insert = Insert(tableName, ignoreIfExist: true)
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.insert(insert);
      if (retId == null) {
        final Update update = updater
            .where(this.id.eq(model.id))
            .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
        retId = adapter.update(update);
      }
    } else {
      final Upsert upsert = upserter
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.upsert(upsert);
    }
    if (cascade) {
      SongLyric newModel;
      if (model.authors != null) {
        newModel ??= await find(model.id);
        for (final child in model.authors) {
          await authorBean.upsert(child, cascade: cascade);
          await songLyricAuthorBean.attach(newModel, child, upsert: true);
        }
      }
      if (model.externals != null) {
        newModel ??= await find(model.id);
        model.externals
            .forEach((x) => externalBean.associateSongLyric(x, newModel));
        for (final child in model.externals) {
          await externalBean.upsert(child, cascade: cascade);
        }
      }
      if (model.tags != null) {
        newModel ??= await find(model.id);
        model.tags.forEach((x) => tagBean.associateSongLyric(x, newModel));
        for (final child in model.tags) {
          await tagBean.upsert(child, cascade: cascade);
        }
      }
      if (model.playlists != null) {
        newModel ??= await find(model.id);
        for (final child in model.playlists) {
          await playlistBean.upsert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(newModel, child, upsert: true);
        }
      }
      if (model.songbooks != null) {
        newModel ??= await find(model.id);
        for (final child in model.songbooks) {
          await songbookBean.upsert(child, cascade: cascade);
          await songbookRecordBean.attach(child, newModel, upsert: true);
        }
      }
      if (model.songs != null) {
        newModel ??= await find(model.id);
        for (final child in model.songs) {
          await songBean.upsert(child, cascade: cascade);
          await songLyricSongBean.attach(newModel, child, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<SongLyric> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    if (cascade || isForeignKeyEnabled) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model,
            cascade: cascade, isForeignKeyEnabled: isForeignKeyEnabled));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(SongLyric model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      SongLyric newModel;
      if (model.authors != null) {
        for (final child in model.authors) {
          await authorBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.externals != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.externals
              .forEach((x) => externalBean.associateSongLyric(x, newModel));
        }
        for (final child in model.externals) {
          await externalBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.tags != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.tags.forEach((x) => tagBean.associateSongLyric(x, newModel));
        }
        for (final child in model.tags) {
          await tagBean.update(child, cascade: cascade, associate: associate);
        }
      }
      if (model.playlists != null) {
        for (final child in model.playlists) {
          await playlistBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.songbooks != null) {
        for (final child in model.songbooks) {
          await songbookBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.songs != null) {
        for (final child in model.songs) {
          await songBean.update(child, cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<SongLyric> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<SongLyric> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final SongLyric model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final SongLyric newModel = await find(id);
      if (newModel != null) {
        await songLyricAuthorBean.detachSongLyric(newModel);
        await externalBean.removeBySongLyric(newModel.id);
        await tagBean.removeBySongLyric(newModel.id);
        await songLyricPlaylistBean.detachSongLyric(newModel);
        await songbookRecordBean.detachSongLyric(newModel);
        await songLyricSongBean.detachSongLyric(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<SongLyric> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<SongLyric> preload(SongLyric model, {bool cascade = false}) async {
    model.authors = await songLyricAuthorBean.fetchBySongLyric(model);
    model.externals = await externalBean.findBySongLyric(model.id,
        preload: cascade, cascade: cascade);
    model.tags = await tagBean.findBySongLyric(model.id,
        preload: cascade, cascade: cascade);
    model.playlists = await songLyricPlaylistBean.fetchBySongLyric(model);
    model.songbooks = await songbookRecordBean.fetchBySongLyric(model);
    model.songs = await songLyricSongBean.fetchBySongLyric(model);
    return model;
  }

  Future<List<SongLyric>> preloadAll(List<SongLyric> models,
      {bool cascade = false}) async {
    for (SongLyric model in models) {
      var temp = await songLyricAuthorBean.fetchBySongLyric(model);
      if (model.authors == null)
        model.authors = temp;
      else {
        model.authors.clear();
        model.authors.addAll(temp);
      }
    }
    models.forEach((SongLyric model) => model.externals ??= []);
    await OneToXHelper.preloadAll<SongLyric, External>(
        models,
        (SongLyric model) => [model.id],
        externalBean.findBySongLyricList,
        (External model) => [model.songLyricId],
        (SongLyric model, External child) =>
            model.externals = List.from(model.externals)..add(child),
        cascade: cascade);
    models.forEach((SongLyric model) => model.tags ??= []);
    await OneToXHelper.preloadAll<SongLyric, Tag>(
        models,
        (SongLyric model) => [model.id],
        tagBean.findBySongLyricList,
        (Tag model) => [model.songLyricId],
        (SongLyric model, Tag child) =>
            model.tags = List.from(model.tags)..add(child),
        cascade: cascade);
    for (SongLyric model in models) {
      var temp = await songLyricPlaylistBean.fetchBySongLyric(model);
      if (model.playlists == null)
        model.playlists = temp;
      else {
        model.playlists.clear();
        model.playlists.addAll(temp);
      }
    }
    for (SongLyric model in models) {
      var temp = await songbookRecordBean.fetchBySongLyric(model);
      if (model.songbooks == null)
        model.songbooks = temp;
      else {
        model.songbooks.clear();
        model.songbooks.addAll(temp);
      }
    }
    for (SongLyric model in models) {
      var temp = await songLyricSongBean.fetchBySongLyric(model);
      if (model.songs == null)
        model.songs = temp;
      else {
        model.songs.clear();
        model.songs.addAll(temp);
      }
    }
    return models;
  }

  SongLyricAuthorBean get songLyricAuthorBean;

  AuthorBean get authorBean;
  ExternalBean get externalBean;
  TagBean get tagBean;
  SongLyricPlaylistBean get songLyricPlaylistBean;

  PlaylistBean get playlistBean;
  SongbookRecordBean get songbookRecordBean;

  SongbookBean get songbookBean;
  SongLyricSongBean get songLyricSongBean;

  SongBean get songBean;
}

abstract class _SongBean implements Bean<Song> {
  final id = IntField('id');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  Song fromMap(Map map) {
    Song model = Song(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(Song model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Song model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Song newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.insert(child, cascade: cascade);
          await songLyricSongBean.attach(child, newModel);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Song> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Song model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    var retId;
    if (isForeignKeyEnabled) {
      final Insert insert = Insert(tableName, ignoreIfExist: true)
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.insert(insert);
      if (retId == null) {
        final Update update = updater
            .where(this.id.eq(model.id))
            .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
        retId = adapter.update(update);
      }
    } else {
      final Upsert upsert = upserter
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.upsert(upsert);
    }
    if (cascade) {
      Song newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.upsert(child, cascade: cascade);
          await songLyricSongBean.attach(child, newModel, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Song> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    if (cascade || isForeignKeyEnabled) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model,
            cascade: cascade, isForeignKeyEnabled: isForeignKeyEnabled));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Song model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Song newModel;
      if (model.songLyrics != null) {
        for (final child in model.songLyrics) {
          await songLyricBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Song> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Song> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Song model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Song newModel = await find(id);
      if (newModel != null) {
        await songLyricSongBean.detachSong(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Song> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Song> preload(Song model, {bool cascade = false}) async {
    model.songLyrics = await songLyricSongBean.fetchBySong(model);
    return model;
  }

  Future<List<Song>> preloadAll(List<Song> models,
      {bool cascade = false}) async {
    for (Song model in models) {
      var temp = await songLyricSongBean.fetchBySong(model);
      if (model.songLyrics == null)
        model.songLyrics = temp;
      else {
        model.songLyrics.clear();
        model.songLyrics.addAll(temp);
      }
    }
    return models;
  }

  SongLyricSongBean get songLyricSongBean;

  SongLyricBean get songLyricBean;
}

abstract class _SongbookBean implements Bean<Songbook> {
  final id = IntField('id');
  final name = StrField('name');
  final shortcut = StrField('shortcut');
  final color = StrField('color');
  final isPrivate = BoolField('is_private');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        shortcut.name: shortcut,
        color.name: color,
        isPrivate.name: isPrivate,
      };
  Songbook fromMap(Map map) {
    Songbook model = Songbook(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      shortcut: adapter.parseValue(map['shortcut']),
      color: adapter.parseValue(map['color']),
      isPrivate: adapter.parseValue(map['is_private']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(Songbook model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(shortcut.set(model.shortcut));
      ret.add(color.set(model.color));
      ret.add(isPrivate.set(model.isPrivate));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(shortcut.name)) ret.add(shortcut.set(model.shortcut));
      if (only.contains(color.name)) ret.add(color.set(model.color));
      if (only.contains(isPrivate.name))
        ret.add(isPrivate.set(model.isPrivate));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.shortcut != null) {
        ret.add(shortcut.set(model.shortcut));
      }
      if (model.color != null) {
        ret.add(color.set(model.color));
      }
      if (model.isPrivate != null) {
        ret.add(isPrivate.set(model.isPrivate));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(shortcut.name, isNullable: false);
    st.addStr(color.name, isNullable: false);
    st.addBool(isPrivate.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Songbook model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Songbook newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.insert(child, cascade: cascade);
          await songbookRecordBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Songbook> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Songbook model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    var retId;
    if (isForeignKeyEnabled) {
      final Insert insert = Insert(tableName, ignoreIfExist: true)
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.insert(insert);
      if (retId == null) {
        final Update update = updater
            .where(this.id.eq(model.id))
            .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
        retId = adapter.update(update);
      }
    } else {
      final Upsert upsert = upserter
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.upsert(upsert);
    }
    if (cascade) {
      Songbook newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.upsert(child, cascade: cascade);
          await songbookRecordBean.attach(newModel, child, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Songbook> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    if (cascade || isForeignKeyEnabled) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model,
            cascade: cascade, isForeignKeyEnabled: isForeignKeyEnabled));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Songbook model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Songbook newModel;
      if (model.songLyrics != null) {
        for (final child in model.songLyrics) {
          await songLyricBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Songbook> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Songbook> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Songbook model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Songbook newModel = await find(id);
      if (newModel != null) {
        await songbookRecordBean.detachSongbook(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Songbook> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Songbook> preload(Songbook model, {bool cascade = false}) async {
    model.songLyrics = await songbookRecordBean.fetchBySongbook(model);
    return model;
  }

  Future<List<Songbook>> preloadAll(List<Songbook> models,
      {bool cascade = false}) async {
    for (Songbook model in models) {
      var temp = await songbookRecordBean.fetchBySongbook(model);
      if (model.songLyrics == null)
        model.songLyrics = temp;
      else {
        model.songLyrics.clear();
        model.songLyrics.addAll(temp);
      }
    }
    return models;
  }

  SongbookRecordBean get songbookRecordBean;

  SongLyricBean get songLyricBean;
}

abstract class _AuthorBean implements Bean<Author> {
  final id = IntField('id');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  Author fromMap(Map map) {
    Author model = Author(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(Author model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Author model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Author newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.insert(child, cascade: cascade);
          await songLyricAuthorBean.attach(child, newModel);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Author> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Author model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    var retId;
    if (isForeignKeyEnabled) {
      final Insert insert = Insert(tableName, ignoreIfExist: true)
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.insert(insert);
      if (retId == null) {
        final Update update = updater
            .where(this.id.eq(model.id))
            .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
        retId = adapter.update(update);
      }
    } else {
      final Upsert upsert = upserter
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.upsert(upsert);
    }
    if (cascade) {
      Author newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.upsert(child, cascade: cascade);
          await songLyricAuthorBean.attach(child, newModel, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Author> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    if (cascade || isForeignKeyEnabled) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model,
            cascade: cascade, isForeignKeyEnabled: isForeignKeyEnabled));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Author model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Author newModel;
      if (model.songLyrics != null) {
        for (final child in model.songLyrics) {
          await songLyricBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Author> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Author> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Author model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Author newModel = await find(id);
      if (newModel != null) {
        await songLyricAuthorBean.detachAuthor(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Author> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Author> preload(Author model, {bool cascade = false}) async {
    model.songLyrics = await songLyricAuthorBean.fetchByAuthor(model);
    return model;
  }

  Future<List<Author>> preloadAll(List<Author> models,
      {bool cascade = false}) async {
    for (Author model in models) {
      var temp = await songLyricAuthorBean.fetchByAuthor(model);
      if (model.songLyrics == null)
        model.songLyrics = temp;
      else {
        model.songLyrics.clear();
        model.songLyrics.addAll(temp);
      }
    }
    return models;
  }

  SongLyricAuthorBean get songLyricAuthorBean;

  SongLyricBean get songLyricBean;
}

abstract class _TagBean implements Bean<Tag> {
  final id = IntField('id');
  final name = StrField('name');
  final type = IntField('type');
  final songLyricId = IntField('song_lyric_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        type.name: type,
        songLyricId.name: songLyricId,
      };
  Tag fromMap(Map map) {
    Tag model = Tag(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      type: adapter.parseValue(map['type']),
    );
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Tag model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(type.set(model.type));
      ret.add(songLyricId.set(model.songLyricId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.type != null) {
        ret.add(type.set(model.type));
      }
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addInt(type.name, isNullable: false);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Tag model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Tag> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Tag model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Tag> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Tag model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Tag> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Tag> find(int id, {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Tag> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Tag>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<Tag>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(Tag child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  SongLyricBean get songLyricBean;
}

abstract class _ExternalBean implements Bean<External> {
  final id = IntField('id');
  final name = StrField('name');
  final mediaId = StrField('media_id');
  final songLyricId = IntField('song_lyric_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        mediaId.name: mediaId,
        songLyricId.name: songLyricId,
      };
  External fromMap(Map map) {
    External model = External(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      mediaId: adapter.parseValue(map['media_id']),
    );
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);

    return model;
  }

  List<SetColumn> toSetColumns(External model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(mediaId.set(model.mediaId));
      ret.add(songLyricId.set(model.songLyricId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(mediaId.name)) ret.add(mediaId.set(model.mediaId));
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.mediaId != null) {
        ret.add(mediaId.set(model.mediaId));
      }
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(mediaId.name, isNullable: false);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(External model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<External> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(External model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<External> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(External model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<External> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<External> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<External> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<External>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<External>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(External child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  SongLyricBean get songLyricBean;
}

abstract class _PlaylistBean implements Bean<Playlist> {
  final id = IntField('id');
  final name = StrField('name');
  final isArchived = BoolField('is_archived');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        isArchived.name: isArchived,
      };
  Playlist fromMap(Map map) {
    Playlist model = Playlist(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      isArchived: adapter.parseValue(map['is_archived']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(Playlist model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(isArchived.set(model.isArchived));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(isArchived.name))
        ret.add(isArchived.set(model.isArchived));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.isArchived != null) {
        ret.add(isArchived.set(model.isArchived));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addBool(isArchived.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Playlist model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Playlist newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.insert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(child, newModel);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Playlist> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Playlist model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    var retId;
    if (isForeignKeyEnabled) {
      final Insert insert = Insert(tableName, ignoreIfExist: true)
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.insert(insert);
      if (retId == null) {
        final Update update = updater
            .where(this.id.eq(model.id))
            .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
        retId = adapter.update(update);
      }
    } else {
      final Upsert upsert = upserter
          .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
      retId = await adapter.upsert(upsert);
    }
    if (cascade) {
      Playlist newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricBean.upsert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(child, newModel, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Playlist> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    if (cascade || isForeignKeyEnabled) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model,
            cascade: cascade, isForeignKeyEnabled: isForeignKeyEnabled));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Playlist model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Playlist newModel;
      if (model.songLyrics != null) {
        for (final child in model.songLyrics) {
          await songLyricBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Playlist> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Playlist> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Playlist model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Playlist newModel = await find(id);
      if (newModel != null) {
        await songLyricPlaylistBean.detachPlaylist(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Playlist> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Playlist> preload(Playlist model, {bool cascade = false}) async {
    model.songLyrics = await songLyricPlaylistBean.fetchByPlaylist(model);
    return model;
  }

  Future<List<Playlist>> preloadAll(List<Playlist> models,
      {bool cascade = false}) async {
    for (Playlist model in models) {
      var temp = await songLyricPlaylistBean.fetchByPlaylist(model);
      if (model.songLyrics == null)
        model.songLyrics = temp;
      else {
        model.songLyrics.clear();
        model.songLyrics.addAll(temp);
      }
    }
    return models;
  }

  SongLyricPlaylistBean get songLyricPlaylistBean;

  SongLyricBean get songLyricBean;
}

abstract class _SongLyricSongBean implements Bean<SongLyricSong> {
  final songLyricId = IntField('song_lyric_id');
  final songId = IntField('song_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        songLyricId.name: songLyricId,
        songId.name: songId,
      };
  SongLyricSong fromMap(Map map) {
    SongLyricSong model = SongLyricSong();
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);
    model.songId = adapter.parseValue(map['song_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongLyricSong model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(songId.set(model.songId));
    } else if (only != null) {
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(songId.name)) ret.add(songId.set(model.songId));
    } else /* if (onlyNonNull) */ {
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
      if (model.songId != null) {
        ret.add(songId.set(model.songId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    st.addInt(songId.name,
        foreignTable: songBean.tableName,
        foreignCol: songBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyricSong model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<SongLyricSong> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(SongLyricSong model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<SongLyricSong> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<void> updateMany(List<SongLyricSong> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<SongLyricSong>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricSong>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(SongLyricSong child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyric(SongLyric model) async {
    final dels = await findBySongLyric(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyric(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songBean.id.eq(t.songId));
      }
      return await songBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Song>> fetchBySongLyric(SongLyric model) async {
    final pivots = await findBySongLyric(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songBean.id.eq(t.songId));
    }
    return await songBean.findWhere(exp);
  }

  Future<List<SongLyricSong>> findBySong(int songId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songId.eq(songId));
    return findMany(find);
  }

  Future<List<SongLyricSong>> findBySongList(List<Song> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Song model in models) {
      find.or(this.songId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySong(int songId) async {
    final Remove rm = remover.where(this.songId.eq(songId));
    return await adapter.remove(rm);
  }

  void associateSong(SongLyricSong child, Song parent) {
    child.songId = parent.id;
  }

  Future<int> detachSong(Song model) async {
    final dels = await findBySong(model.id);
    if (dels.isNotEmpty) {
      await removeBySong(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songLyricBean.id.eq(t.songLyricId));
      }
      return await songLyricBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyric>> fetchBySong(Song model) async {
    final pivots = await findBySong(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricBean.id.eq(t.songLyricId));
    }
    return await songLyricBean.findWhere(exp);
  }

  Future<dynamic> attach(SongLyric one, Song two, {bool upsert = false}) async {
    final ret = SongLyricSong();
    ret.songLyricId = one.id;
    ret.songId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  SongLyricBean get songLyricBean;
  SongBean get songBean;
}

abstract class _SongbookRecordBean implements Bean<SongbookRecord> {
  final number = StrField('number');
  final songLyricId = IntField('song_lyric_id');
  final songbookId = IntField('songbook_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        number.name: number,
        songLyricId.name: songLyricId,
        songbookId.name: songbookId,
      };
  SongbookRecord fromMap(Map map) {
    SongbookRecord model = SongbookRecord(
      number: adapter.parseValue(map['number']),
    );
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);
    model.songbookId = adapter.parseValue(map['songbook_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongbookRecord model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(number.set(model.number));
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(songbookId.set(model.songbookId));
    } else if (only != null) {
      if (only.contains(number.name)) ret.add(number.set(model.number));
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(songbookId.name))
        ret.add(songbookId.set(model.songbookId));
    } else /* if (onlyNonNull) */ {
      if (model.number != null) {
        ret.add(number.set(model.number));
      }
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
      if (model.songbookId != null) {
        ret.add(songbookId.set(model.songbookId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(number.name, isNullable: false);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    st.addInt(songbookId.name,
        foreignTable: songbookBean.tableName,
        foreignCol: songbookBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongbookRecord model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<SongbookRecord> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(SongbookRecord model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<SongbookRecord> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<void> updateMany(List<SongbookRecord> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<SongbookRecord>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongbookRecord>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(SongbookRecord child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyric(SongLyric model) async {
    final dels = await findBySongLyric(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyric(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songbookBean.id.eq(t.songbookId));
      }
      return await songbookBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Songbook>> fetchBySongLyric(SongLyric model) async {
    final pivots = await findBySongLyric(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songbookBean.id.eq(t.songbookId));
    }
    return await songbookBean.findWhere(exp);
  }

  Future<List<SongbookRecord>> findBySongbook(int songbookId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songbookId.eq(songbookId));
    return findMany(find);
  }

  Future<List<SongbookRecord>> findBySongbookList(List<Songbook> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Songbook model in models) {
      find.or(this.songbookId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongbook(int songbookId) async {
    final Remove rm = remover.where(this.songbookId.eq(songbookId));
    return await adapter.remove(rm);
  }

  void associateSongbook(SongbookRecord child, Songbook parent) {
    child.songbookId = parent.id;
  }

  Future<int> detachSongbook(Songbook model) async {
    final dels = await findBySongbook(model.id);
    if (dels.isNotEmpty) {
      await removeBySongbook(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songLyricBean.id.eq(t.songLyricId));
      }
      return await songLyricBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyric>> fetchBySongbook(Songbook model) async {
    final pivots = await findBySongbook(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricBean.id.eq(t.songLyricId));
    }
    return await songLyricBean.findWhere(exp);
  }

  Future<dynamic> attach(Songbook one, SongLyric two,
      {bool upsert = false}) async {
    final ret = SongbookRecord();
    ret.songbookId = one.id;
    ret.songLyricId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  SongLyricBean get songLyricBean;
  SongbookBean get songbookBean;
}

abstract class _SongLyricAuthorBean implements Bean<SongLyricAuthor> {
  final songLyricId = IntField('song_lyric_id');
  final authorId = IntField('author_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        songLyricId.name: songLyricId,
        authorId.name: authorId,
      };
  SongLyricAuthor fromMap(Map map) {
    SongLyricAuthor model = SongLyricAuthor();
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);
    model.authorId = adapter.parseValue(map['author_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongLyricAuthor model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(authorId.set(model.authorId));
    } else if (only != null) {
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(authorId.name)) ret.add(authorId.set(model.authorId));
    } else /* if (onlyNonNull) */ {
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
      if (model.authorId != null) {
        ret.add(authorId.set(model.authorId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    st.addInt(authorId.name,
        foreignTable: authorBean.tableName,
        foreignCol: authorBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyricAuthor model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<SongLyricAuthor> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(SongLyricAuthor model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<SongLyricAuthor> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<void> updateMany(List<SongLyricAuthor> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<SongLyricAuthor>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricAuthor>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(SongLyricAuthor child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyric(SongLyric model) async {
    final dels = await findBySongLyric(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyric(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(authorBean.id.eq(t.authorId));
      }
      return await authorBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Author>> fetchBySongLyric(SongLyric model) async {
    final pivots = await findBySongLyric(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(authorBean.id.eq(t.authorId));
    }
    return await authorBean.findWhere(exp);
  }

  Future<List<SongLyricAuthor>> findByAuthor(int authorId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.authorId.eq(authorId));
    return findMany(find);
  }

  Future<List<SongLyricAuthor>> findByAuthorList(List<Author> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Author model in models) {
      find.or(this.authorId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByAuthor(int authorId) async {
    final Remove rm = remover.where(this.authorId.eq(authorId));
    return await adapter.remove(rm);
  }

  void associateAuthor(SongLyricAuthor child, Author parent) {
    child.authorId = parent.id;
  }

  Future<int> detachAuthor(Author model) async {
    final dels = await findByAuthor(model.id);
    if (dels.isNotEmpty) {
      await removeByAuthor(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songLyricBean.id.eq(t.songLyricId));
      }
      return await songLyricBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyric>> fetchByAuthor(Author model) async {
    final pivots = await findByAuthor(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricBean.id.eq(t.songLyricId));
    }
    return await songLyricBean.findWhere(exp);
  }

  Future<dynamic> attach(SongLyric one, Author two,
      {bool upsert = false}) async {
    final ret = SongLyricAuthor();
    ret.songLyricId = one.id;
    ret.authorId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  SongLyricBean get songLyricBean;
  AuthorBean get authorBean;
}

abstract class _SongLyricPlaylistBean implements Bean<SongLyricPlaylist> {
  final songLyricId = IntField('song_lyric_id');
  final playlistId = IntField('playlist_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        songLyricId.name: songLyricId,
        playlistId.name: playlistId,
      };
  SongLyricPlaylist fromMap(Map map) {
    SongLyricPlaylist model = SongLyricPlaylist();
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);
    model.playlistId = adapter.parseValue(map['playlist_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongLyricPlaylist model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(playlistId.set(model.playlistId));
    } else if (only != null) {
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(playlistId.name))
        ret.add(playlistId.set(model.playlistId));
    } else /* if (onlyNonNull) */ {
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
      if (model.playlistId != null) {
        ret.add(playlistId.set(model.playlistId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(songLyricId.name,
        foreignTable: songLyricBean.tableName,
        foreignCol: songLyricBean.id.name,
        isNullable: false);
    st.addInt(playlistId.name,
        foreignTable: playlistBean.tableName,
        foreignCol: playlistBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyricPlaylist model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<SongLyricPlaylist> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(SongLyricPlaylist model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<SongLyricPlaylist> models,
      {bool onlyNonNull = false,
      Set<String> only,
      isForeignKeyEnabled = false}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<void> updateMany(List<SongLyricPlaylist> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<SongLyricPlaylist>> findBySongLyric(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricPlaylist>> findBySongLyricList(List<SongLyric> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyric model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyric(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyric(SongLyricPlaylist child, SongLyric parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyric(SongLyric model) async {
    final dels = await findBySongLyric(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyric(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(playlistBean.id.eq(t.playlistId));
      }
      return await playlistBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Playlist>> fetchBySongLyric(SongLyric model) async {
    final pivots = await findBySongLyric(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(playlistBean.id.eq(t.playlistId));
    }
    return await playlistBean.findWhere(exp);
  }

  Future<List<SongLyricPlaylist>> findByPlaylist(int playlistId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.playlistId.eq(playlistId));
    return findMany(find);
  }

  Future<List<SongLyricPlaylist>> findByPlaylistList(List<Playlist> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Playlist model in models) {
      find.or(this.playlistId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByPlaylist(int playlistId) async {
    final Remove rm = remover.where(this.playlistId.eq(playlistId));
    return await adapter.remove(rm);
  }

  void associatePlaylist(SongLyricPlaylist child, Playlist parent) {
    child.playlistId = parent.id;
  }

  Future<int> detachPlaylist(Playlist model) async {
    final dels = await findByPlaylist(model.id);
    if (dels.isNotEmpty) {
      await removeByPlaylist(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songLyricBean.id.eq(t.songLyricId));
      }
      return await songLyricBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyric>> fetchByPlaylist(Playlist model) async {
    final pivots = await findByPlaylist(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricBean.id.eq(t.songLyricId));
    }
    return await songLyricBean.findWhere(exp);
  }

  Future<dynamic> attach(SongLyric one, Playlist two,
      {bool upsert = false}) async {
    final ret = SongLyricPlaylist();
    ret.songLyricId = one.id;
    ret.playlistId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  SongLyricBean get songLyricBean;
  PlaylistBean get playlistBean;
}
