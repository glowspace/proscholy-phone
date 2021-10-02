import 'package:zpevnik/models/tag.dart';

class TagsSection {
  final String title;
  final List<Tag> tags;

  TagsSection(this.title, this.tags);
}

class TagsProvider {
  late List<TagsSection> _sections;

  TagsProvider(List<Tag> tags) {
    final tagsMap = Map<String, List<Tag>>.from({});

    for (final tag in tags) {
      if (!tag.type.supported) continue;

      final description = tag.type.description;

      if (tagsMap[description] == null) tagsMap[description] = List<Tag>.empty(growable: true);

      tagsMap[description]?.add(Tag.clone(tag));
    }

    _sections = tagsMap.entries.map((entry) => TagsSection(entry.key, entry.value)).toList();

    _sections.sort((first, second) => first.tags[0].type.rawValue.compareTo(second.tags[0].type.rawValue));
  }

  List<TagsSection> get sections => _sections;
}
