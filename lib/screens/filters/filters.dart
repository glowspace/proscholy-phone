import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/screens/filters/section.dart';

class FiltersWidget extends StatelessWidget {
  final TagsProvider provider;

  const FiltersWidget({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: PrimaryScrollController.of(context),
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      addRepaintBoundaries: false,
      itemCount: provider.sections.length,
      itemBuilder: (context, index) => FiltersSection(
        title: provider.sections[index].title,
        tags: provider.sections[index].tags,
        isLast: index == provider.sections.length - 1,
      ),
    );
  }
}
