import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/utils/platform.dart';

abstract class Searchable {
  void search(String searchText);
}

class SearchWidget extends StatefulWidget {
  final String placeholder;
  final Searchable searchable;

  final Widget leading;
  final Widget trailing;

  const SearchWidget({
    Key key,
    this.placeholder,
    this.searchable,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> with PlatformStateMixin {
  @override
  Widget iOSWidget(BuildContext context) => _body(
        context,
        CupertinoTextField(
          placeholder: widget.placeholder,
          onChanged: (searchText) => widget.searchable.search(searchText),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _body(
        context,
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.placeholder,
          ),
          onChanged: (searchText) => widget.searchable.search(searchText),
        ),
      );

  Widget _body(BuildContext context, Widget textField) => Container(
        child: Row(
          children: [
            if (widget.leading != null) widget.leading,
            Expanded(child: textField),
            if (widget.trailing != null) widget.trailing,
          ],
        ),
      );
}
