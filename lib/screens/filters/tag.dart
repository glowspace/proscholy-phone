import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/theme.dart';

class FilterTag extends StatefulWidget {
  final Tag tag;

  const FilterTag({Key key, this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterTagState();
}

class _FilterTagState extends State<FilterTag> {
  bool _selected;

  @override
  void initState() {
    super.initState();

    _selected = false;
  }

  @override
  Widget build(BuildContext context) => Consumer<TagsProvider>(
        builder: (context, provider, _) => GestureDetector(
          onTap: () {
            provider.select(widget.tag);
            setState(() => _selected = !_selected);
          },
          child: Container(
            decoration: BoxDecoration(
              color: _selected
                  ? widget.tag.type.selectedColor
                  : Colors.transparent,
              border:
                  Border.all(color: AppTheme.shared.filterBorderColor(context)),
              borderRadius:
                  BorderRadius.all(Radius.circular(_size(context).height)),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 4),
            child: Text(
              widget.tag.name,
              style: AppTheme.shared.filterTextStyle(context),
            ),
          ),
        ),
      );

  Size _size(BuildContext context) =>
      (context.findRenderObject() as RenderBox)?.size ?? Size.zero;
}
