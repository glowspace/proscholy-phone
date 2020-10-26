import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProvider extends ChangeNotifier {
  final String _url = 'https://zpevnik.proscholy.cz/graphql';

  String _progressInfo;
  String get progressInfo => _progressInfo;

  UpdateProvider() {
    _progressInfo = '';
  }

  Future<void> update() async {
    // _update();
  }

  void _update() {
    _progressInfo = 'Aktualizace písní';
    notifyListeners();

    final client = Client();

    client.post(_url, body: <String, String>{
      'query': ''
    }, headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8'
    });
  }
}
