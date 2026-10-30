import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/utils/fts_search.dart';

extension AppDependenciesView on AppDependencies {
  FTSSearch get ftsSearch => FTSSearch(database: ftsDatabase, store: store);
}
