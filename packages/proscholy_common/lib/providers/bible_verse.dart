import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

part 'generated/bible_verse.g.dart';

@riverpod
BibleVerse? bibleVerse(Ref ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider).store.box<BibleVerse>();

  final stream = box.query(BibleVerse_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
