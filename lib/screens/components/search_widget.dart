import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SearchWidget extends StatefulWidget {
  final String placeholder;
  final FocusNode focusNode;
  final Function(String) search;

  final Widget prefix;
  final Widget suffix;

  const SearchWidget({
    Key key,
    this.placeholder,
    this.focusNode,
    @required this.search,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> with PlatformStateMixin {
  final _textController = TextEditingController();

  @override
  initState() {
    super.initState();

    _textController.text = PageStorage.of(context)?.readState(context) as String ?? '';
  }

  @override
  Widget iOSWidget(BuildContext context) => _body(
        context,
        CupertinoTextField(
          key: PageStorageKey('text_field'),
          decoration: BoxDecoration(color: Colors.transparent),
          focusNode: widget.focusNode,
          placeholder: widget.placeholder,
          controller: _textController,
          onChanged: _searchTextChanged,
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _body(
        context,
        TextField(
          key: PageStorageKey('text_field'),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.placeholder,
          ),
          focusNode: widget.focusNode,
          controller: _textController,
          onChanged: _searchTextChanged,
        ),
      );

  Widget _body(BuildContext context, Widget child) => Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemeNew.of(context).borderColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          if (widget.prefix != null) widget.prefix,
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(child: child),
            ),
          ),
          if (widget.suffix != null) widget.suffix,
        ]),
      );

  void _searchTextChanged(String searchText) {
    // store current searchText to keep it persistent between tab changes
    PageStorage.of(context)?.writeState(context, searchText);

    widget.search(searchText);
  }
}
