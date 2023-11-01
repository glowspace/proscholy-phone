import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

part 'bible_verse.g.dart';

@riverpod
BibleVerse? bibleVerse(BibleVerseRef ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<BibleVerse>()));

  final stream = box.query(BibleVerse_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
