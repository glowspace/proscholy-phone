import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/components/filters/filters_section.dart';

class FiltersWidget extends StatelessWidget {
  final List<TagsSection> tagsSections;

  const FiltersWidget({Key? key, required this.tagsSections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: PrimaryScrollController.of(context),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      addRepaintBoundaries: false,
      itemCount: tagsSections.length,
      itemBuilder: (context, index) => FiltersSection(
        title: tagsSections[index].title,
        tags: tagsSections[index].tags,
        isLast: index == tagsSections.length - 1,
      ),
    );
  }
}
