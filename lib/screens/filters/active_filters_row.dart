import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/screens/filters/tag.dart';

class ActiveFiltersRow extends StatelessWidget {
  final List<Tag> selectedTags;

  const ActiveFiltersRow({Key key, this.selectedTags}) : super(key: key);

  @override
  Widget build(BuildContext context) => selectedTags.isNotEmpty
      ? Scrollbar(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding / 3, vertical: kDefaultPadding / 3),
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                  child: Icon(Icons.filter_list),
                ),
                Row(
                  children: List.generate(
                    selectedTags.length,
                    (index) => Container(
                      padding: EdgeInsets.only(right: kDefaultPadding / 4),
                      child: FilterTag(tag: selectedTags[index], cancellable: true),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        )
      : Container();
}
