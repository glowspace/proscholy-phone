import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/screens/filters/tag.dart';
import 'package:zpevnik/theme.dart';

class FiltersSection extends StatelessWidget {
  final String title;
  final List<Tag> tags;
  final bool isLast;

  const FiltersSection({
    Key? key,
    required this.title,
    required this.tags,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final textStyle = appTheme.titleTextStyle?.copyWith(color: appTheme.filtersTextColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle),
              SizedBox(height: kDefaultPadding),
              Wrap(
                spacing: kDefaultPadding / 2,
                runSpacing: kDefaultPadding / 4,
                children: List.generate(tags.length, (index) => FilterTag(tag: tags[index])),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(thickness: 1, color: appTheme.filtersSectionSeparatorColor),
      ],
    );
  }
}
