// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beans.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _SongLyricBean implements Bean<SongLyricEntity> {
  final id = IntField('id');
  final name = StrField('name');
  final lyrics = StrField('lyrics');
  final language = StrField('language');
  final type = IntField('type');
  final favoriteOrder = IntField('favorite_order');
  final transposition = IntField('transposition');
  final showChords = BoolField('show_chords');
  final accidentals = BoolField('accidentals');
  final songId = IntField('song_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        lyrics.name: lyrics,
        language.name: language,
        type.name: type,
        favoriteOrder.name: favoriteOrder,
        transposition.name: transposition,
        showChords.name: showChords,
        accidentals.name: accidentals,
        songId.name: songId,
      };
  SongLyricEntity fromMap(Map map) {
    SongLyricEntity model = SongLyricEntity(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      lyrics: adapter.parseValue(map['lyrics']),
      language: adapter.parseValue(map['language']),
      type: adapter.parseValue(map['type']),
    );
    model.favoriteOrder = adapter.parseValue(map['favorite_order']);
    model.transposition = adapter.parseValue(map['transposition']);
    model.showChords = adapter.parseValue(map['show_chords']);
    model.accidentals = adapter.parseValue(map['accidentals']);
    model.songId = adapter.parseValue(map['song_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongLyricEntity model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(lyrics.set(model.lyrics));
      ret.add(language.set(model.language));
      ret.add(type.set(model.type));
      ret.add(favoriteOrder.set(model.favoriteOrder));
      ret.add(transposition.set(model.transposition));
      ret.add(showChords.set(model.showChords));
      ret.add(accidentals.set(model.accidentals));
      ret.add(songId.set(model.songId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(lyrics.name)) ret.add(lyrics.set(model.lyrics));
      if (only.contains(language.name)) ret.add(language.set(model.language));
      if (only.contains(type.name)) ret.add(type.set(model.type));
      if (only.contains(favoriteOrder.name))
        ret.add(favoriteOrder.set(model.favoriteOrder));
      if (only.contains(transposition.name))
        ret.add(transposition.set(model.transposition));
      if (only.contains(showChords.name))
        ret.add(showChords.set(model.showChords));
      if (only.contains(accidentals.name))
        ret.add(accidentals.set(model.accidentals));
      if (only.contains(songId.name)) ret.add(songId.set(model.songId));
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
      if (model.favoriteOrder != null) {
        ret.add(favoriteOrder.set(model.favoriteOrder));
      }
      if (model.transposition != null) {
        ret.add(transposition.set(model.transposition));
      }
      if (model.showChords != null) {
        ret.add(showChords.set(model.showChords));
      }
      if (model.accidentals != null) {
        ret.add(accidentals.set(model.accidentals));
      }
      if (model.songId != null) {
        ret.add(songId.set(model.songId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(lyrics.name, isNullable: true);
    st.addStr(language.name, isNullable: false);
    st.addInt(type.name, isNullable: false);
    st.addInt(favoriteOrder.name, isNullable: true);
    st.addInt(transposition.name, isNullable: true);
    st.addBool(showChords.name, isNullable: true);
    st.addBool(accidentals.name, isNullable: true);
    st.addInt(songId.name,
        foreignTable: songBean.tableName,
        foreignCol: songBean.id.name,
        isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyricEntity model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      SongLyricEntity newModel;
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
            .forEach((x) => externalBean.associateSongLyricEntity(x, newModel));
        for (final child in model.externals) {
          await externalBean.insert(child, cascade: cascade);
        }
      }
      if (model.tags != null) {
        newModel ??= await find(model.id);
        for (final child in model.tags) {
          await tagEntityBean.insert(child, cascade: cascade);
          await songLyricTagBean.attach(child, newModel);
        }
      }
      if (model.playlists != null) {
        newModel ??= await find(model.id);
        for (final child in model.playlists) {
          await playlistBean.insert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(newModel, child);
        }
      }
      if (model.songbookRecords != null) {
        newModel ??= await find(model.id);
        model.songbookRecords.forEach(
            (x) => songbookRecordBean.associateSongLyricEntity(x, newModel));
        for (final child in model.songbookRecords) {
          await songbookRecordBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<SongLyricEntity> models,
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

  Future<dynamic> upsert(SongLyricEntity model,
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
      SongLyricEntity newModel;
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
            .forEach((x) => externalBean.associateSongLyricEntity(x, newModel));
        for (final child in model.externals) {
          await externalBean.upsert(child, cascade: cascade);
        }
      }
      if (model.tags != null) {
        newModel ??= await find(model.id);
        for (final child in model.tags) {
          await tagEntityBean.upsert(child, cascade: cascade);
          await songLyricTagBean.attach(child, newModel, upsert: true);
        }
      }
      if (model.playlists != null) {
        newModel ??= await find(model.id);
        for (final child in model.playlists) {
          await playlistBean.upsert(child, cascade: cascade);
          await songLyricPlaylistBean.attach(newModel, child, upsert: true);
        }
      }
      if (model.songbookRecords != null) {
        newModel ??= await find(model.id);
        model.songbookRecords.forEach(
            (x) => songbookRecordBean.associateSongLyricEntity(x, newModel));
        for (final child in model.songbookRecords) {
          await songbookRecordBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<SongLyricEntity> models,
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

  Future<int> update(SongLyricEntity model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      SongLyricEntity newModel;
      if (model.authors != null) {
        for (final child in model.authors) {
          await authorBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.externals != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.externals.forEach(
              (x) => externalBean.associateSongLyricEntity(x, newModel));
        }
        for (final child in model.externals) {
          await externalBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.tags != null) {
        for (final child in model.tags) {
          await tagEntityBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.playlists != null) {
        for (final child in model.playlists) {
          await playlistBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.songbookRecords != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.songbookRecords.forEach(
              (x) => songbookRecordBean.associateSongLyricEntity(x, newModel));
        }
        for (final child in model.songbookRecords) {
          await songbookRecordBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<SongLyricEntity> models,
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

  Future<SongLyricEntity> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final SongLyricEntity model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final SongLyricEntity newModel = await find(id);
      if (newModel != null) {
        await songLyricAuthorBean.detachSongLyricEntity(newModel);
        await externalBean.removeBySongLyricEntity(newModel.id);
        await songLyricTagBean.detachSongLyricEntity(newModel);
        await songLyricPlaylistBean.detachSongLyricEntity(newModel);
        await songbookRecordBean.removeBySongLyricEntity(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<SongLyricEntity> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<SongLyricEntity>> findBySong(int songId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songId.eq(songId));
    final List<SongLyricEntity> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<SongLyricEntity>> findBySongList(List<Song> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Song model in models) {
      find.or(this.songId.eq(model.id));
    }
    final List<SongLyricEntity> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeBySong(int songId) async {
    final Remove rm = remover.where(this.songId.eq(songId));
    return await adapter.remove(rm);
  }

  void associateSong(SongLyricEntity child, Song parent) {
    child.songId = parent.id;
  }

  Future<SongLyricEntity> preload(SongLyricEntity model,
      {bool cascade = false}) async {
    model.authors = await songLyricAuthorBean.fetchBySongLyricEntity(model);
    model.externals = await externalBean.findBySongLyricEntity(model.id,
        preload: cascade, cascade: cascade);
    model.tags = await songLyricTagBean.fetchBySongLyricEntity(model);
    model.playlists = await songLyricPlaylistBean.fetchBySongLyricEntity(model);
    model.songbookRecords = await songbookRecordBean
        .findBySongLyricEntity(model.id, preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<SongLyricEntity>> preloadAll(List<SongLyricEntity> models,
      {bool cascade = false}) async {
    for (SongLyricEntity model in models) {
      var temp = await songLyricAuthorBean.fetchBySongLyricEntity(model);
      if (model.authors == null)
        model.authors = temp;
      else {
        model.authors.clear();
        model.authors.addAll(temp);
      }
    }
    models.forEach((SongLyricEntity model) => model.externals ??= []);
    await OneToXHelper.preloadAll<SongLyricEntity, External>(
        models,
        (SongLyricEntity model) => [model.id],
        externalBean.findBySongLyricEntityList,
        (External model) => [model.songLyricId],
        (SongLyricEntity model, External child) =>
            model.externals = List.from(model.externals)..add(child),
        cascade: cascade);
    for (SongLyricEntity model in models) {
      var temp = await songLyricTagBean.fetchBySongLyricEntity(model);
      if (model.tags == null)
        model.tags = temp;
      else {
        model.tags.clear();
        model.tags.addAll(temp);
      }
    }
    for (SongLyricEntity model in models) {
      var temp = await songLyricPlaylistBean.fetchBySongLyricEntity(model);
      if (model.playlists == null)
        model.playlists = temp;
      else {
        model.playlists.clear();
        model.playlists.addAll(temp);
      }
    }
    models.forEach((SongLyricEntity model) => model.songbookRecords ??= []);
    await OneToXHelper.preloadAll<SongLyricEntity, SongbookRecord>(
        models,
        (SongLyricEntity model) => [model.id],
        songbookRecordBean.findBySongLyricEntityList,
        (SongbookRecord model) => [model.songLyricId],
        (SongLyricEntity model, SongbookRecord child) => model.songbookRecords =
            List.from(model.songbookRecords)..add(child),
        cascade: cascade);
    return models;
  }

  SongLyricAuthorBean get songLyricAuthorBean;

  AuthorBean get authorBean;
  ExternalBean get externalBean;
  SongLyricTagBean get songLyricTagBean;

  TagBean get tagEntityBean;
  SongLyricPlaylistBean get songLyricPlaylistBean;

  PlaylistBean get playlistBean;
  SongbookRecordBean get songbookRecordBean;
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
        model.songLyrics
            .forEach((x) => songLyricEntityBean.associateSong(x, newModel));
        for (final child in model.songLyrics) {
          await songLyricEntityBean.insert(child, cascade: cascade);
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
        model.songLyrics
            .forEach((x) => songLyricEntityBean.associateSong(x, newModel));
        for (final child in model.songLyrics) {
          await songLyricEntityBean.upsert(child, cascade: cascade);
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
        if (associate) {
          newModel ??= await find(model.id);
          model.songLyrics
              .forEach((x) => songLyricEntityBean.associateSong(x, newModel));
        }
        for (final child in model.songLyrics) {
          await songLyricEntityBean.update(child,
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
        await songLyricEntityBean.removeBySong(newModel.id);
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
    model.songLyrics = await songLyricEntityBean.findBySong(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Song>> preloadAll(List<Song> models,
      {bool cascade = false}) async {
    models.forEach((Song model) => model.songLyrics ??= []);
    await OneToXHelper.preloadAll<Song, SongLyricEntity>(
        models,
        (Song model) => [model.id],
        songLyricEntityBean.findBySongList,
        (SongLyricEntity model) => [model.songId],
        (Song model, SongLyricEntity child) =>
            model.songLyrics = List.from(model.songLyrics)..add(child),
        cascade: cascade);
    return models;
  }

  SongLyricBean get songLyricEntityBean;
}

abstract class _SongbookBean implements Bean<SongbookEntity> {
  final id = IntField('id');
  final name = StrField('name');
  final shortcut = StrField('shortcut');
  final color = StrField('color');
  final isPrivate = BoolField('is_private');
  final isPinned = BoolField('is_pinned');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        shortcut.name: shortcut,
        color.name: color,
        isPrivate.name: isPrivate,
        isPinned.name: isPinned,
      };
  SongbookEntity fromMap(Map map) {
    SongbookEntity model = SongbookEntity(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      shortcut: adapter.parseValue(map['shortcut']),
      color: adapter.parseValue(map['color']),
      isPrivate: adapter.parseValue(map['is_private']),
    );
    model.isPinned = adapter.parseValue(map['is_pinned']);

    return model;
  }

  List<SetColumn> toSetColumns(SongbookEntity model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(shortcut.set(model.shortcut));
      ret.add(color.set(model.color));
      ret.add(isPrivate.set(model.isPrivate));
      ret.add(isPinned.set(model.isPinned));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(shortcut.name)) ret.add(shortcut.set(model.shortcut));
      if (only.contains(color.name)) ret.add(color.set(model.color));
      if (only.contains(isPrivate.name))
        ret.add(isPrivate.set(model.isPrivate));
      if (only.contains(isPinned.name)) ret.add(isPinned.set(model.isPinned));
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
      if (model.isPinned != null) {
        ret.add(isPinned.set(model.isPinned));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addStr(shortcut.name, isNullable: false);
    st.addStr(color.name, isNullable: true);
    st.addBool(isPrivate.name, isNullable: false);
    st.addBool(isPinned.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongbookEntity model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      SongbookEntity newModel;
      if (model.records != null) {
        newModel ??= await find(model.id);
        model.records.forEach(
            (x) => songbookRecordBean.associateSongbookEntity(x, newModel));
        for (final child in model.records) {
          await songbookRecordBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<SongbookEntity> models,
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

  Future<dynamic> upsert(SongbookEntity model,
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
      SongbookEntity newModel;
      if (model.records != null) {
        newModel ??= await find(model.id);
        model.records.forEach(
            (x) => songbookRecordBean.associateSongbookEntity(x, newModel));
        for (final child in model.records) {
          await songbookRecordBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<SongbookEntity> models,
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

  Future<int> update(SongbookEntity model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      SongbookEntity newModel;
      if (model.records != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.records.forEach(
              (x) => songbookRecordBean.associateSongbookEntity(x, newModel));
        }
        for (final child in model.records) {
          await songbookRecordBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<SongbookEntity> models,
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

  Future<SongbookEntity> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final SongbookEntity model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final SongbookEntity newModel = await find(id);
      if (newModel != null) {
        await songbookRecordBean.removeBySongbookEntity(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<SongbookEntity> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<SongbookEntity> preload(SongbookEntity model,
      {bool cascade = false}) async {
    model.records = await songbookRecordBean.findBySongbookEntity(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<SongbookEntity>> preloadAll(List<SongbookEntity> models,
      {bool cascade = false}) async {
    models.forEach((SongbookEntity model) => model.records ??= []);
    await OneToXHelper.preloadAll<SongbookEntity, SongbookRecord>(
        models,
        (SongbookEntity model) => [model.id],
        songbookRecordBean.findBySongbookEntityList,
        (SongbookRecord model) => [model.songbookId],
        (SongbookEntity model, SongbookRecord child) =>
            model.records = List.from(model.records)..add(child),
        cascade: cascade);
    return models;
  }

  SongbookRecordBean get songbookRecordBean;
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
          await songLyricEntityBean.insert(child, cascade: cascade);
          await songLyricAuthorBean.attach(child, newModel);
        }
      }
      if (model.externals != null) {
        newModel ??= await find(model.id);
        for (final child in model.externals) {
          await externalBean.insert(child, cascade: cascade);
          await authorExternalBean.attach(child, newModel);
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
          await songLyricEntityBean.upsert(child, cascade: cascade);
          await songLyricAuthorBean.attach(child, newModel, upsert: true);
        }
      }
      if (model.externals != null) {
        newModel ??= await find(model.id);
        for (final child in model.externals) {
          await externalBean.upsert(child, cascade: cascade);
          await authorExternalBean.attach(child, newModel, upsert: true);
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
          await songLyricEntityBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.externals != null) {
        for (final child in model.externals) {
          await externalBean.update(child,
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
        await authorExternalBean.detachAuthor(newModel);
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
    model.externals = await authorExternalBean.fetchByAuthor(model);
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
    for (Author model in models) {
      var temp = await authorExternalBean.fetchByAuthor(model);
      if (model.externals == null)
        model.externals = temp;
      else {
        model.externals.clear();
        model.externals.addAll(temp);
      }
    }
    return models;
  }

  SongLyricAuthorBean get songLyricAuthorBean;

  SongLyricBean get songLyricEntityBean;
  AuthorExternalBean get authorExternalBean;

  ExternalBean get externalBean;
}

abstract class _TagBean implements Bean<TagEntity> {
  final id = IntField('id');
  final name = StrField('name');
  final type = IntField('type');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        type.name: type,
      };
  TagEntity fromMap(Map map) {
    TagEntity model = TagEntity(
      id: adapter.parseValue(map['id']),
      name: adapter.parseValue(map['name']),
      type: adapter.parseValue(map['type']),
    );

    return model;
  }

  List<SetColumn> toSetColumns(TagEntity model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(type.set(model.type));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(type.name)) ret.add(type.set(model.type));
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
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addInt(type.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(TagEntity model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      TagEntity newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricEntityBean.insert(child, cascade: cascade);
          await songLyricTagBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<TagEntity> models,
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

  Future<dynamic> upsert(TagEntity model,
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
      TagEntity newModel;
      if (model.songLyrics != null) {
        newModel ??= await find(model.id);
        for (final child in model.songLyrics) {
          await songLyricEntityBean.upsert(child, cascade: cascade);
          await songLyricTagBean.attach(newModel, child, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<TagEntity> models,
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

  Future<int> update(TagEntity model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      TagEntity newModel;
      if (model.songLyrics != null) {
        for (final child in model.songLyrics) {
          await songLyricEntityBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<TagEntity> models,
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

  Future<TagEntity> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final TagEntity model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final TagEntity newModel = await find(id);
      if (newModel != null) {
        await songLyricTagBean.detachTagEntity(newModel);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<TagEntity> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<TagEntity> preload(TagEntity model, {bool cascade = false}) async {
    model.songLyrics = await songLyricTagBean.fetchByTagEntity(model);
    return model;
  }

  Future<List<TagEntity>> preloadAll(List<TagEntity> models,
      {bool cascade = false}) async {
    for (TagEntity model in models) {
      var temp = await songLyricTagBean.fetchByTagEntity(model);
      if (model.songLyrics == null)
        model.songLyrics = temp;
      else {
        model.songLyrics.clear();
        model.songLyrics.addAll(temp);
      }
    }
    return models;
  }

  SongLyricTagBean get songLyricTagBean;

  SongLyricBean get songLyricEntityBean;
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
    st.addStr(mediaId.name, isNullable: true);
    st.addInt(songLyricId.name,
        foreignTable: songLyricEntityBean.tableName,
        foreignCol: songLyricEntityBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(External model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      External newModel;
      if (model.authors != null) {
        newModel ??= await find(model.id);
        for (final child in model.authors) {
          await authorBean.insert(child, cascade: cascade);
          await authorExternalBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<External> models,
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

  Future<dynamic> upsert(External model,
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
      External newModel;
      if (model.authors != null) {
        newModel ??= await find(model.id);
        for (final child in model.authors) {
          await authorBean.upsert(child, cascade: cascade);
          await authorExternalBean.attach(newModel, child, upsert: true);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<External> models,
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

  Future<int> update(External model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      External newModel;
      if (model.authors != null) {
        for (final child in model.authors) {
          await authorBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<External> models,
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

  Future<External> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final External model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final External newModel = await find(id);
      if (newModel != null) {
        await authorExternalBean.detachExternal(newModel);
      }
    }
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

  Future<List<External>> findBySongLyricEntity(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    final List<External> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<External>> findBySongLyricEntityList(List<SongLyricEntity> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyricEntity model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    final List<External> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeBySongLyricEntity(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyricEntity(External child, SongLyricEntity parent) {
    child.songLyricId = parent.id;
  }

  Future<External> preload(External model, {bool cascade = false}) async {
    model.authors = await authorExternalBean.fetchByExternal(model);
    return model;
  }

  Future<List<External>> preloadAll(List<External> models,
      {bool cascade = false}) async {
    for (External model in models) {
      var temp = await authorExternalBean.fetchByExternal(model);
      if (model.authors == null)
        model.authors = temp;
      else {
        model.authors.clear();
        model.authors.addAll(temp);
      }
    }
    return models;
  }

  AuthorExternalBean get authorExternalBean;

  AuthorBean get authorBean;
  SongLyricBean get songLyricEntityBean;
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
          await songLyricEntityBean.insert(child, cascade: cascade);
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
          await songLyricEntityBean.upsert(child, cascade: cascade);
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
          await songLyricEntityBean.update(child,
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

  SongLyricBean get songLyricEntityBean;
}

abstract class _SongbookRecordBean implements Bean<SongbookRecord> {
  final id = IntField('id');
  final number = StrField('number');
  final songLyricId = IntField('song_lyric_id');
  final songbookId = IntField('songbook_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        number.name: number,
        songLyricId.name: songLyricId,
        songbookId.name: songbookId,
      };
  SongbookRecord fromMap(Map map) {
    SongbookRecord model = SongbookRecord(
      id: adapter.parseValue(map['id']),
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
      ret.add(id.set(model.id));
      ret.add(number.set(model.number));
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(songbookId.set(model.songbookId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(number.name)) ret.add(number.set(model.number));
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(songbookId.name))
        ret.add(songbookId.set(model.songbookId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
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
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(number.name, isNullable: false);
    st.addInt(songLyricId.name,
        foreignTable: songLyricEntityBean.tableName,
        foreignCol: songLyricEntityBean.id.name,
        isNullable: false);
    st.addInt(songbookId.name,
        foreignTable: songbookEntityBean.tableName,
        foreignCol: songbookEntityBean.id.name,
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

  Future<int> update(SongbookRecord model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<SongbookRecord> models,
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

  Future<SongbookRecord> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<SongbookRecord> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<SongbookRecord>> findBySongLyricEntity(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongbookRecord>> findBySongLyricEntityList(
      List<SongLyricEntity> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyricEntity model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyricEntity(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyricEntity(SongbookRecord child, SongLyricEntity parent) {
    child.songLyricId = parent.id;
  }

  Future<List<SongbookRecord>> findBySongbookEntity(int songbookId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songbookId.eq(songbookId));
    return findMany(find);
  }

  Future<List<SongbookRecord>> findBySongbookEntityList(
      List<SongbookEntity> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongbookEntity model in models) {
      find.or(this.songbookId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongbookEntity(int songbookId) async {
    final Remove rm = remover.where(this.songbookId.eq(songbookId));
    return await adapter.remove(rm);
  }

  void associateSongbookEntity(SongbookRecord child, SongbookEntity parent) {
    child.songbookId = parent.id;
  }

  SongLyricBean get songLyricEntityBean;
  SongbookBean get songbookEntityBean;
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
        foreignTable: songLyricEntityBean.tableName,
        foreignCol: songLyricEntityBean.id.name,
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

  Future<List<SongLyricAuthor>> findBySongLyricEntity(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricAuthor>> findBySongLyricEntityList(
      List<SongLyricEntity> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyricEntity model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyricEntity(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyricEntity(SongLyricAuthor child, SongLyricEntity parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyricEntity(SongLyricEntity model) async {
    final dels = await findBySongLyricEntity(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyricEntity(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(authorBean.id.eq(t.authorId));
      }
      return await authorBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Author>> fetchBySongLyricEntity(SongLyricEntity model) async {
    final pivots = await findBySongLyricEntity(model.id);
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
        exp.or(songLyricEntityBean.id.eq(t.songLyricId));
      }
      return await songLyricEntityBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyricEntity>> fetchByAuthor(Author model) async {
    final pivots = await findByAuthor(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricEntityBean.id.eq(t.songLyricId));
    }
    return await songLyricEntityBean.findWhere(exp);
  }

  Future<dynamic> attach(SongLyricEntity one, Author two,
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

  SongLyricBean get songLyricEntityBean;
  AuthorBean get authorBean;
}

abstract class _SongLyricTagBean implements Bean<SongLyricTag> {
  final songLyricId = IntField('song_lyric_id');
  final tagId = IntField('tag_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        songLyricId.name: songLyricId,
        tagId.name: tagId,
      };
  SongLyricTag fromMap(Map map) {
    SongLyricTag model = SongLyricTag();
    model.songLyricId = adapter.parseValue(map['song_lyric_id']);
    model.tagId = adapter.parseValue(map['tag_id']);

    return model;
  }

  List<SetColumn> toSetColumns(SongLyricTag model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(songLyricId.set(model.songLyricId));
      ret.add(tagId.set(model.tagId));
    } else if (only != null) {
      if (only.contains(songLyricId.name))
        ret.add(songLyricId.set(model.songLyricId));
      if (only.contains(tagId.name)) ret.add(tagId.set(model.tagId));
    } else /* if (onlyNonNull) */ {
      if (model.songLyricId != null) {
        ret.add(songLyricId.set(model.songLyricId));
      }
      if (model.tagId != null) {
        ret.add(tagId.set(model.tagId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(songLyricId.name,
        foreignTable: songLyricEntityBean.tableName,
        foreignCol: songLyricEntityBean.id.name,
        isNullable: false);
    st.addInt(tagId.name,
        foreignTable: tagEntityBean.tableName,
        foreignCol: tagEntityBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(SongLyricTag model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<SongLyricTag> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(SongLyricTag model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<SongLyricTag> models,
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

  Future<void> updateMany(List<SongLyricTag> models,
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

  Future<List<SongLyricTag>> findBySongLyricEntity(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricTag>> findBySongLyricEntityList(
      List<SongLyricEntity> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyricEntity model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyricEntity(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyricEntity(SongLyricTag child, SongLyricEntity parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyricEntity(SongLyricEntity model) async {
    final dels = await findBySongLyricEntity(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyricEntity(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(tagEntityBean.id.eq(t.tagId));
      }
      return await tagEntityBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<TagEntity>> fetchBySongLyricEntity(SongLyricEntity model) async {
    final pivots = await findBySongLyricEntity(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(tagEntityBean.id.eq(t.tagId));
    }
    return await tagEntityBean.findWhere(exp);
  }

  Future<List<SongLyricTag>> findByTagEntity(int tagId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.tagId.eq(tagId));
    return findMany(find);
  }

  Future<List<SongLyricTag>> findByTagEntityList(List<TagEntity> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (TagEntity model in models) {
      find.or(this.tagId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByTagEntity(int tagId) async {
    final Remove rm = remover.where(this.tagId.eq(tagId));
    return await adapter.remove(rm);
  }

  void associateTagEntity(SongLyricTag child, TagEntity parent) {
    child.tagId = parent.id;
  }

  Future<int> detachTagEntity(TagEntity model) async {
    final dels = await findByTagEntity(model.id);
    if (dels.isNotEmpty) {
      await removeByTagEntity(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(songLyricEntityBean.id.eq(t.songLyricId));
      }
      return await songLyricEntityBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyricEntity>> fetchByTagEntity(TagEntity model) async {
    final pivots = await findByTagEntity(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricEntityBean.id.eq(t.songLyricId));
    }
    return await songLyricEntityBean.findWhere(exp);
  }

  Future<dynamic> attach(TagEntity one, SongLyricEntity two,
      {bool upsert = false}) async {
    final ret = SongLyricTag();
    ret.tagId = one.id;
    ret.songLyricId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  SongLyricBean get songLyricEntityBean;
  TagBean get tagEntityBean;
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
        foreignTable: songLyricEntityBean.tableName,
        foreignCol: songLyricEntityBean.id.name,
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

  Future<List<SongLyricPlaylist>> findBySongLyricEntity(int songLyricId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.songLyricId.eq(songLyricId));
    return findMany(find);
  }

  Future<List<SongLyricPlaylist>> findBySongLyricEntityList(
      List<SongLyricEntity> models,
      {bool preload = false,
      bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (SongLyricEntity model in models) {
      find.or(this.songLyricId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeBySongLyricEntity(int songLyricId) async {
    final Remove rm = remover.where(this.songLyricId.eq(songLyricId));
    return await adapter.remove(rm);
  }

  void associateSongLyricEntity(
      SongLyricPlaylist child, SongLyricEntity parent) {
    child.songLyricId = parent.id;
  }

  Future<int> detachSongLyricEntity(SongLyricEntity model) async {
    final dels = await findBySongLyricEntity(model.id);
    if (dels.isNotEmpty) {
      await removeBySongLyricEntity(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(playlistBean.id.eq(t.playlistId));
      }
      return await playlistBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Playlist>> fetchBySongLyricEntity(SongLyricEntity model) async {
    final pivots = await findBySongLyricEntity(model.id);
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
        exp.or(songLyricEntityBean.id.eq(t.songLyricId));
      }
      return await songLyricEntityBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<SongLyricEntity>> fetchByPlaylist(Playlist model) async {
    final pivots = await findByPlaylist(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(songLyricEntityBean.id.eq(t.songLyricId));
    }
    return await songLyricEntityBean.findWhere(exp);
  }

  Future<dynamic> attach(SongLyricEntity one, Playlist two,
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

  SongLyricBean get songLyricEntityBean;
  PlaylistBean get playlistBean;
}

abstract class _AuthorExternalBean implements Bean<AuthorExternal> {
  final authorId = IntField('author_id');
  final externalId = IntField('external_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        authorId.name: authorId,
        externalId.name: externalId,
      };
  AuthorExternal fromMap(Map map) {
    AuthorExternal model = AuthorExternal();
    model.authorId = adapter.parseValue(map['author_id']);
    model.externalId = adapter.parseValue(map['external_id']);

    return model;
  }

  List<SetColumn> toSetColumns(AuthorExternal model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(authorId.set(model.authorId));
      ret.add(externalId.set(model.externalId));
    } else if (only != null) {
      if (only.contains(authorId.name)) ret.add(authorId.set(model.authorId));
      if (only.contains(externalId.name))
        ret.add(externalId.set(model.externalId));
    } else /* if (onlyNonNull) */ {
      if (model.authorId != null) {
        ret.add(authorId.set(model.authorId));
      }
      if (model.externalId != null) {
        ret.add(externalId.set(model.externalId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(authorId.name,
        foreignTable: authorBean.tableName,
        foreignCol: authorBean.id.name,
        isNullable: false);
    st.addInt(externalId.name,
        foreignTable: externalBean.tableName,
        foreignCol: externalBean.id.name,
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(AuthorExternal model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<AuthorExternal> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(AuthorExternal model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      isForeignKeyEnabled = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<AuthorExternal> models,
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

  Future<void> updateMany(List<AuthorExternal> models,
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

  Future<List<AuthorExternal>> findByAuthor(int authorId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.authorId.eq(authorId));
    return findMany(find);
  }

  Future<List<AuthorExternal>> findByAuthorList(List<Author> models,
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

  void associateAuthor(AuthorExternal child, Author parent) {
    child.authorId = parent.id;
  }

  Future<int> detachAuthor(Author model) async {
    final dels = await findByAuthor(model.id);
    if (dels.isNotEmpty) {
      await removeByAuthor(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(externalBean.id.eq(t.externalId));
      }
      return await externalBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<External>> fetchByAuthor(Author model) async {
    final pivots = await findByAuthor(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(externalBean.id.eq(t.externalId));
    }
    return await externalBean.findWhere(exp);
  }

  Future<List<AuthorExternal>> findByExternal(int externalId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.externalId.eq(externalId));
    return findMany(find);
  }

  Future<List<AuthorExternal>> findByExternalList(List<External> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (External model in models) {
      find.or(this.externalId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByExternal(int externalId) async {
    final Remove rm = remover.where(this.externalId.eq(externalId));
    return await adapter.remove(rm);
  }

  void associateExternal(AuthorExternal child, External parent) {
    child.externalId = parent.id;
  }

  Future<int> detachExternal(External model) async {
    final dels = await findByExternal(model.id);
    if (dels.isNotEmpty) {
      await removeByExternal(model.id);
      final exp = Or();
      for (final t in dels) {
        exp.or(authorBean.id.eq(t.authorId));
      }
      return await authorBean.removeWhere(exp);
    }
    return 0;
  }

  Future<List<Author>> fetchByExternal(External model) async {
    final pivots = await findByExternal(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];
    final exp = Or();
    for (final t in pivots) {
      exp.or(authorBean.id.eq(t.authorId));
    }
    return await authorBean.findWhere(exp);
  }

  Future<dynamic> attach(External one, Author two,
      {bool upsert = false}) async {
    final ret = AuthorExternal();
    ret.externalId = one.id;
    ret.authorId = two.id;
    if (!upsert) {
      return insert(ret);
    } else {
      return this.upsert(ret);
    }
  }

  AuthorBean get authorBean;
  ExternalBean get externalBean;
}
