List<T> readJsonList<T>(List<dynamic> jsonList, {required T Function(Map<String, dynamic>) mapper}) {
  return [for (final json in jsonList) mapper(json)];
}
