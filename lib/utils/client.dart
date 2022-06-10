import 'dart:convert';

import 'package:http/http.dart' as http;

final _url = Uri.https('zpevnik.proscholy.cz', 'graphql');

const _newsQuery = '''
query {
  news_items(active: true) {
    id
    text
    link
    expires_at
  }
}
''';

class Client {
  static Future<Map<String, dynamic>> getNews() async {
    final body = {'query': _newsQuery};

    final response = await http.post(_url, body: body);

    return jsonDecode(response.body);
  }
}
