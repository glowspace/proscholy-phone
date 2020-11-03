import 'package:flutter/material.dart';
import 'package:zpevnik/models/tag.dart';

class TagsProvider extends ChangeNotifier {
  List<TagsSection> _sections;
  Map<Tag, bool> _selectedTags;

  TagsProvider(List<Tag> tags) {
    Map<String, List<Tag>> tagsMap = {};

    for (final tag in tags) {
      if (!tag.type.supported) continue;

      if (tagsMap[tag.type.description] == null) tagsMap[tag.type.description] = [];

      tagsMap[tag.type.description].add(tag);
    }

    _sections = tagsMap.entries.map((entry) => TagsSection(entry.key, entry.value)).toList()
      ..sort((first, second) => first.tags[0].type.rawValue.compareTo(second.tags[0].type.rawValue));

    _selectedTags = {};
  }

  List<TagsSection> get sections => _sections;

  List<Tag> get selectedTags => _selectedTags.keys.toList();

  void select(Tag tag, bool select) {
    if (select)
      _selectedTags[tag] = true;
    else
      _selectedTags.remove(tag);

    notifyListeners();
  }

  bool isSelected(Tag tag) => _selectedTags.containsKey(tag);
}

class TagsSection {
  final String title;
  final List<Tag> tags;

  TagsSection(this.title, this.tags);
}
