import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

part 'generated/user_text.g.dart';

@riverpod
UserText? userText(Ref ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider).store.box<UserText>();

  final stream = box.query(UserText_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
