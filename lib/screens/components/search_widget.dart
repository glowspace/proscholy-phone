import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SearchWidget extends StatefulWidget {
  final String placeholder;
  final Function(String) search;
  final FocusNode focusNode;

  final Widget leading;
  final Widget trailing;

  const SearchWidget({
    Key key,
    this.placeholder,
    this.search,
    this.focusNode,
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
          onChanged: searchTextChanged,
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _body(
        context,
        LayoutBuilder(
          builder: (context, constraints) => TextField(
            key: PageStorageKey('text_field'),
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: _textStyle(context, widget.placeholder, constraints.maxWidth),
            ),
            controller: TextEditingController()..text = PageStorage.of(context)?.readState(context) as String ?? '',
            onChanged: searchTextChanged,
          ),
        ),
      );

  Widget _body(BuildContext context, Widget textField) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.shared.filterBorderColor(context)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          if (widget.leading != null) widget.leading,
          Expanded(child: textField),
          if (widget.trailing != null) widget.trailing,
        ]),
      );

  void searchTextChanged(String searchText) {
    PageStorage.of(context)?.writeState(context, searchText);

    widget.search(searchText);
  }

  TextStyle _textStyle(BuildContext context, String text, double width) {
    double fontSize = 17;
    Size size;

    do {
      size = (TextPainter(
        text: TextSpan(
          text: text,
          style: AppTheme.shared.searchFieldPlaceholderColorTextStyle(context).copyWith(fontSize: fontSize),
        ),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr,
      )..layout())
          .size;

      fontSize -= 0.5;
    } while (size.width > width);

    return AppTheme.shared.searchFieldPlaceholderColorTextStyle(context).copyWith(fontSize: fontSize);
  }
}
