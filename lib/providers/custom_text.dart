import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

part 'custom_text.g.dart';

@riverpod
CustomText? customText(CustomTextRef ref, int id) {
  if (id == 0) return null;

  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store.box<CustomText>()));

  final stream = box.query(CustomText_.id.equals(id)).watch();
  final subscription = stream.listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  return box.get(id);
}
