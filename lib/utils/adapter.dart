import 'package:jaguar_query_sqflite/composer.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

String _composeInsert(final Insert st) {
  final ImmutableInsertStatement info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('INSERT OR IGNORE');
  sb.write(' INTO ');
  sb.write(info.table);
  sb.write('(');

  sb.write(info.values.keys.join(', '));

  sb.write(') VALUES (');
  sb.write(info.values.values.map(composeValue).join(', '));
  sb.write(')');

  return sb.toString();
}

class CustomAdapter extends SqfliteAdapter {
  CustomAdapter(String path, {int version}) : super(path, version: version);

  @override
  Future<T> insert<T>(Insert st) {
    return connection.rawInsert(_composeInsert(st)) as Future<T>;
  }
}
