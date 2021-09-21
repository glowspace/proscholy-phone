import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const authorsTable = SqfEntityTable(
  tableName: 'authors',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'Author',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
  ],
);

const externalsTable = SqfEntityTable(
  tableName: 'externals',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'External',
  fields: [
    SqfEntityField('public_name', DbType.text, isNotNull: true),
    SqfEntityField('media_id', DbType.text),
    SqfEntityField('media_type', DbType.text),
    SqfEntityFieldRelationship(
      parentTable: authorsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songLyricsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.ONE_TO_MANY,
    ),
  ],
);

const playlistsTable = SqfEntityTable(
  tableName: 'playlists',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: 'Playlist',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('is_archived', DbType.bool, isNotNull: true, defaultValue: false),
    SqfEntityField('rank', DbType.integer, isNotNull: true),
  ],
);

const songsTable = SqfEntityTable(
  tableName: 'songs',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'Song',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
  ],
);

const songbooksTable = SqfEntityTable(
  tableName: 'songbooks',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'Songbook',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('shortcut', DbType.text),
    SqfEntityField('color', DbType.text),
    SqfEntityField('color_text', DbType.text),
    SqfEntityField('is_private', DbType.bool, isNotNull: true),
    SqfEntityField('is_pinned', DbType.bool, isNotNull: true, defaultValue: false),
  ],
);

const songbookRecordsTable = SqfEntityTable(
  tableName: 'songbook_records',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongbookRecord',
  fields: [
    SqfEntityField('number', DbType.text, isNotNull: true),
    SqfEntityFieldRelationship(
      parentTable: songbooksTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.ONE_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songLyricsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.ONE_TO_MANY,
    ),
  ],
);

const songLyricsTable = SqfEntityTable(
  tableName: 'song_lyrics',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'SongLyric',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('secondary_name_1', DbType.text),
    SqfEntityField('secondary_name_2', DbType.text),
    SqfEntityField('lyrics', DbType.text),
    SqfEntityField('lang_string', DbType.text),
    SqfEntityField('type_enum', DbType.text),
    // FIXME: store it as raw data instead of string
    SqfEntityField('lilypond_svg', DbType.text),
    SqfEntityField('favorite_rank', DbType.integer),
    SqfEntityField('transposition', DbType.integer, defaultValue: 0),
    SqfEntityField('show_chords', DbType.bool),
    SqfEntityField('accidentals', DbType.integer),
    SqfEntityFieldRelationship(
      parentTable: authorsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: playlistsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.MANY_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: songsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.ONE_TO_MANY,
    ),
    SqfEntityFieldRelationship(
      parentTable: tagsTable,
      deleteRule: DeleteRule.CASCADE,
      relationType: RelationType.MANY_TO_MANY,
    ),
  ],
);

const tagsTable = SqfEntityTable(
  tableName: 'tags',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: false,
  modelName: 'Tag',
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('type_enum', DbType.text, isNotNull: true),
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
