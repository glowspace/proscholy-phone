import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const authorsTable = SqfEntityTable(
  tableName: 'authors',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'AuthorEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
  ],
);

const externalsTable = SqfEntityTable(
  tableName: 'externals',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'ExternalEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('mediaId', DbType.text),
    SqfEntityField('mediaType', DbType.text),
    SqfEntityFieldRelationship(
      parentTable: authorsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songLyricsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.ONE_TO_MANY,
    ),
  ],
);

const playlistsTable = SqfEntityTable(
  tableName: 'playlists',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'PlaylistEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('isArchived', DbType.bool, isNotNull: true, defaultValue: false),
    SqfEntityField('order', DbType.integer, isNotNull: true),
  ],
);

const songsTable = SqfEntityTable(
  tableName: 'songs',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
  ],
);

const songbooksTable = SqfEntityTable(
  tableName: 'songbooks',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongbookEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('shortcut', DbType.text, isNotNull: true),
    SqfEntityField('color', DbType.text),
    SqfEntityField('colorText', DbType.text),
    SqfEntityField('isPrivate', DbType.bool, isNotNull: true),
    SqfEntityField('isPinned', DbType.bool, isNotNull: true, defaultValue: false),
  ],
);

const songbookRecordsTable = SqfEntityTable(
  tableName: 'songbook_records',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongbookRecordEntity',
  fields: [
    SqfEntityField('number', DbType.text, isNotNull: true),
    SqfEntityFieldRelationship(
      parentTable: songbooksTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.ONE_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songLyricsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.ONE_TO_MANY,
    ),
  ],
);

const songLyricsTable = SqfEntityTable(
  tableName: 'song_lyrics',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongLyricEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('secondaryName1', DbType.text),
    SqfEntityField('secondaryName2', DbType.text),
    SqfEntityField('lyrics', DbType.text),
    SqfEntityField('language', DbType.text),
    SqfEntityField('type', DbType.integer),
    // fixme: store it as raw data instead of string
    SqfEntityField('lilypond', DbType.text),
    SqfEntityField('favoriteOrder', DbType.integer),
    SqfEntityField('transposition', DbType.integer),
    SqfEntityField('showChords', DbType.bool),
    SqfEntityField('accidentals', DbType.integer),
    SqfEntityFieldRelationship(
      parentTable: authorsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: playlistsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.ONE_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: tagsTable,
      deleteRule: DeleteRule.NO_ACTION,
      relationType: RelationType.MANY_TO_MANY,
    ),
  ],
);

const tagsTable = SqfEntityTable(
  tableName: 'tags',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'TagEntity',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('type', DbType.integer, isNotNull: true),
  ],
);

@SqfEntityBuilder(model)
const model = SqfEntityModel(
  modelName: 'model',
  databaseName: 'zpevnik_proscholy.db',
  password: null,
  databaseTables: [
    authorsTable,
    externalsTable,
    playlistsTable,
    songsTable,
    songbooksTable,
    songbookRecordsTable,
    songLyricsTable,
    tagsTable,
  ],
  formTables: [],
  sequences: [],
  dbVersion: 1,
);
