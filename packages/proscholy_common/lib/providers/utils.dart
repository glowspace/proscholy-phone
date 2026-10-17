import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';

int nextId<T extends Identifiable, D>(Ref ref, QueryProperty<T, D> idProperty) {
  final box = ref.read(appDependenciesProvider).store.box<T>();
  final queryBuilder = box.query()..order(idProperty, flags: Order.descending);
  final query = queryBuilder.build();
  final lastId = query.findFirst()?.id ?? 0;

  query.close();

  return lastId + 1;
}

List<T> queryStore<T, D>(
  Ref ref, {
  Condition<T>? condition,
  QueryProperty<T, D>? orderBy,
  // default ascending
  int orderFlags = 0,
  bool listen = true,
}) {
  final box = ref.read(appDependenciesProvider).store.box<T>();
  final queryBuilder = box.query(condition);

  if (orderBy != null) queryBuilder.order(orderBy, flags: orderFlags);

  if (listen) {
    // create stream from new query, otherwise crashes (SEGFAULT)
    final stream = box.query(condition).watch();
    final subscription = stream.listen((_) => ref.invalidateSelf());

    ref.onDispose(subscription.cancel);
  }

  final query = queryBuilder.build();
  final data = query.find();

  query.close();

  return data;
}
