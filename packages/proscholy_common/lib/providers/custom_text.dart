import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

part 'generated/custom_text.g.dart';

@riverpod
CustomText? customText(CustomTextRef ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider).store.box<CustomText>();

  final stream = box.query(CustomText_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
