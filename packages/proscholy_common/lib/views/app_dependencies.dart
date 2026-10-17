import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/utils/fts_search.dart';

extension AppDependenciesView on AppDependencies {
  FTSSearch get ftsSearch => FTSSearch(database: ftsDatabase, songLyricsBox: store.box<SongLyric>());
}
