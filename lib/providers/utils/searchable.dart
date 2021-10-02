import 'package:flutter/material.dart';

mixin Searchable<T> on ChangeNotifier {
  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String newValue) => _searchText = newValue;

  List<T> get items;

  void onSubmitted(BuildContext context) {}
}
