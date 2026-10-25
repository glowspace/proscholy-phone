import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

part 'generated/bible_passage.g.dart';

@riverpod
BiblePassage? biblePassage(Ref ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider).store.box<BiblePassage>();

  final stream = box.query(BiblePassage_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
