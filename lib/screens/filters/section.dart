import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/screens/filters/tag.dart';
import 'package:zpevnik/theme.dart';

class FiltersSection extends StatelessWidget {
  final String title;
  final List<Tag> tags;

  const FiltersSection({Key key, this.title, this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline6.copyWith(color: AppTheme.of(context).filtersTextColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: kDefaultPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: EdgeInsets.only(bottom: kDefaultPadding), child: Text(title, style: textStyle)),
              Wrap(
                spacing: kDefaultPadding / 2,
                runSpacing: kDefaultPadding / 2,
                children: List.generate(tags.length, (index) => FilterTag(tag: tags[index])),
              ),
            ],
          ),
        ),
        Divider(thickness: 2, color: AppTheme.of(context).filtersSectionSeparatorColor),
      ],
    );
  }
}
