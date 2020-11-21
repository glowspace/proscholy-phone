import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/theme.dart';

class FilterTag extends StatelessWidget {
  final Tag tag;
  final bool cancellable;

  const FilterTag({Key key, this.tag, this.cancellable = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(color: AppTheme.shared.filtersTextColor(context));

    return Consumer<TagsProvider>(
      builder: (context, provider, _) => GestureDetector(
        onTap: cancellable ? null : () => provider.select(tag, !provider.isSelected(tag)),
        child: Container(
          decoration: BoxDecoration(
            color: provider.isSelected(tag) && !cancellable ? tag.type.selectedColor : Colors.transparent,
            border: Border.all(color: AppTheme.shared.filterBorderColor(context)),
            borderRadius: BorderRadius.all(Radius.circular(100)), // big enough number to make it always full circular
          ),
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 4),
          child: cancellable
              ? Row(children: [
                  Text(tag.name, style: textStyle),
                  GestureDetector(
                    onTap: () => provider.select(tag, false),
                    child: Container(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.close, size: 12),
                    ),
                  ),
                ])
              : Text(tag.name, style: textStyle),
        ),
      ),
    );
  }
}
