import 'package:flutter/material.dart';
import 'package:zpevnik/models/tag.dart';

class TagsProvider extends ChangeNotifier {
  Map<String, List<Tag>> _tags;
  List<Tag> _selectedTags;

  TagsProvider(List<Tag> tags) {
    _tags = {};

    for (final tag in tags) {
      if (!tag.type.supported) continue;

      if (_tags[tag.type.description] == null) _tags[tag.type.description] = [];

      _tags[tag.type.description].add(tag);
    }

    _selectedTags = [];
  }

  Map<String, List<Tag>> get tags => _tags;

  List<Tag> get selectedTags => _selectedTags;

  void select(Tag tag, {bool select = true}) {
    if (select)
      _selectedTags.add(tag);
    else
      _selectedTags.remove(tag);
  }
}
