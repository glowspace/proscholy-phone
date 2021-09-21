import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/screens/filters/tag.dart';
import 'package:zpevnik/theme.dart';

class ActiveFiltersRow extends StatelessWidget {
  final List<Tag> selectedTags;

  const ActiveFiltersRow({Key? key, required this.selectedTags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedTags.isEmpty) return Container();

    return Scrollbar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding / 3, vertical: kDefaultPadding / 3),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Icon(Icons.filter_list, color: AppTheme.of(context).iconColor),
            ),
            Row(
              children: List.generate(
                selectedTags.length,
                (index) => Container(
                    padding: EdgeInsets.only(right: kDefaultPadding / 2),
                    child: FilterTag(tag: selectedTags[index], isPartOfActiveTags: true)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
