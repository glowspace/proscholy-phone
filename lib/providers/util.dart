import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/internal.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

int nextId<T extends Identifiable, D>(Ref ref, QueryProperty<T, D> idProperty) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<T>();
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
  int orderFlags = 0,
}) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<T>();
  final queryBuilder = box.query(condition);

  if (orderBy != null) queryBuilder.order(orderBy, flags: orderFlags);

  final query = queryBuilder.build();
  final data = query.find();

  query.close();

  return data;
}
