import 'package:collection/collection.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/data_provider.dart';

class Songbook {
  final SongbookEntity _entity;

  List<SongLyric> _songLyrics;

  Songbook(this._entity);

  String get name => _entity.name;

  String get shortcut => _entity.shortcut;

  // todo: probably can be optmized using db, but it's good enough for now
  List<SongLyric> get songLyrics => _songLyrics ??= DataProvider.shared.songLyrics
      .where((songLyric) => songLyric.entity.songbookRecords.any((record) => record.songbookId == _entity.id))
      .toList()
        ..sort((first, second) => compareNatural(
            first.entity.songbookRecords.firstWhere((record) => record.songbookId == _entity.id).number,
            (second.entity.songbookRecords.firstWhere((record) => record.songbookId == _entity.id).number)));
}
