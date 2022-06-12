// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../models/news_item.dart';
import '../models/song_lyric.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 4828503391288265608),
      name: 'NewsItem',
      lastPropertyId: const IdUid(4, 2798094153154113871),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9186643213110364361),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2012362637196544559),
            name: 'text',
            type: 9,
            flags: 2048,
            indexId: const IdUid(1, 6571528058855447311)),
        ModelProperty(
            id: const IdUid(3, 4198504091761231768),
            name: 'link',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2798094153154113871),
            name: 'expiresAt',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 3997966892313177785),
      name: 'SongLyric',
      lastPropertyId: const IdUid(3, 57379581087889430),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2769258185308251592),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 2750485277817544042),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 57379581087889430),
            name: 'lyrics',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 3997966892313177785),
      lastIndexId: const IdUid(1, 6571528058855447311),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    NewsItem: EntityDefinition<NewsItem>(
        model: _entities[0],
        toOneRelations: (NewsItem object) => [],
        toManyRelations: (NewsItem object) => {},
        getId: (NewsItem object) => object.id,
        setId: (NewsItem object, int id) {
          if (object.id != id) {
            throw ArgumentError('Field NewsItem.id is read-only '
                '(final or getter-only) and it was declared to be self-assigned. '
                'However, the currently inserted object (.id=${object.id}) '
                "doesn't match the inserted ID (ID $id). "
                'You must assign an ID before calling [box.put()].');
          }
        },
        objectToFB: (NewsItem object, fb.Builder fbb) {
          final textOffset = fbb.writeString(object.text);
          final linkOffset = fbb.writeString(object.link);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, textOffset);
          fbb.addOffset(2, linkOffset);
          fbb.addInt64(3, object.expiresAt?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final expiresAtValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final object = NewsItem(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              expiresAtValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(expiresAtValue));

          return object;
        }),
    SongLyric: EntityDefinition<SongLyric>(
        model: _entities[1],
        toOneRelations: (SongLyric object) => [],
        toManyRelations: (SongLyric object) => {},
        getId: (SongLyric object) => object.id,
        setId: (SongLyric object, int id) {
          if (object.id != id) {
            throw ArgumentError('Field SongLyric.id is read-only '
                '(final or getter-only) and it was declared to be self-assigned. '
                'However, the currently inserted object (.id=${object.id}) '
                "doesn't match the inserted ID (ID $id). "
                'You must assign an ID before calling [box.put()].');
          }
        },
        objectToFB: (SongLyric object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final lyricsOffset =
              object.lyrics == null ? null : fbb.writeString(object.lyrics!);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, lyricsOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SongLyric(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [NewsItem] entity fields to define ObjectBox queries.
class NewsItem_ {
  /// see [NewsItem.id]
  static final id = QueryIntegerProperty<NewsItem>(_entities[0].properties[0]);

  /// see [NewsItem.text]
  static final text = QueryStringProperty<NewsItem>(_entities[0].properties[1]);

  /// see [NewsItem.link]
  static final link = QueryStringProperty<NewsItem>(_entities[0].properties[2]);

  /// see [NewsItem.expiresAt]
  static final expiresAt =
      QueryIntegerProperty<NewsItem>(_entities[0].properties[3]);
}

/// [SongLyric] entity fields to define ObjectBox queries.
class SongLyric_ {
  /// see [SongLyric.id]
  static final id = QueryIntegerProperty<SongLyric>(_entities[1].properties[0]);

  /// see [SongLyric.name]
  static final name =
      QueryStringProperty<SongLyric>(_entities[1].properties[1]);

  /// see [SongLyric.lyrics]
  static final lyrics =
      QueryStringProperty<SongLyric>(_entities[1].properties[2]);
}
