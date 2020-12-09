import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SearchWidget extends StatefulWidget {
  final String placeholder;
  final FocusNode focusNode;
  final Function(String) search;
  final Function(String) onSubmitted;

  final Widget prefix;
  final Widget suffix;

  const SearchWidget({
    Key key,
    this.placeholder,
    this.focusNode,
    @required this.search,
    this.onSubmitted,
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
        LayoutBuilder(
          builder: (context, constraints) => Container(
            child: CupertinoTextField(
              key: PageStorageKey('text_field'),
              decoration: BoxDecoration(color: Colors.transparent),
              focusNode: widget.focusNode,
              placeholder: widget.placeholder,
              placeholderStyle: _placeholderStyle(context, constraints.maxWidth - 12), // - 12 for textfield padding
              controller: _textController,
              onChanged: _searchTextChanged,
              onSubmitted: widget.onSubmitted,
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _body(
        context,
        LayoutBuilder(
          builder: (context, constraints) => TextField(
            key: PageStorageKey('text_field'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: _placeholderStyle(context, constraints.maxWidth),
            ),
            focusNode: widget.focusNode,
            controller: _textController,
            onChanged: _searchTextChanged,
            onSubmitted: widget.onSubmitted,
          ),
        ),
      );

  Widget _body(BuildContext context, Widget child) => Container(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        margin: AppTheme.of(context).isIOS ? null : EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(
          color: AppTheme.of(context).backgroundColor,
          border: Border.all(color: AppTheme.of(context).borderColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          if (widget.prefix != null) widget.prefix,
          Expanded(child: child),
          if (widget.suffix != null) widget.suffix,
        ]),
      );

  void _searchTextChanged(String searchText) {
    // store current searchText to keep it persistent between tab changes
    PageStorage.of(context)?.writeState(context, searchText);

    widget.search(searchText);
  }

  // could not find good way with fittedbox, so compute fontSize, that will fit
  TextStyle _placeholderStyle(BuildContext context, double width) {
    double fontSize = 17;
    TextStyle textStyle;
    double textWidth;

    do {
      textStyle = AppTheme.of(context).placeholderTextStyle.copyWith(fontSize: fontSize);
      fontSize -= 0.5;

      textWidth = (TextPainter(
        text: TextSpan(text: widget.placeholder, style: textStyle),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr,
      )..layout())
          .size
          .width;
    } while (textWidth > width);

    return textStyle;
  }
}
