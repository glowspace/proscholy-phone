import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

class SearchWidget extends StatefulWidget {
  final String placeholder;
  final Function(String) search;

  final Widget leading;
  final Widget trailing;

  const SearchWidget({
    Key key,
    this.placeholder,
    this.search,
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
          onChanged: (searchText) => widget.search(searchText),
        ),
      );

  @override
  Widget androidWidget(BuildContext context) => _body(
        context,
        LayoutBuilder(
          builder: (context, constraints) => TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: _textStyle(context, widget.placeholder, constraints.maxWidth),
            ),
            onChanged: (searchText) => widget.search(searchText),
          ),
        ),
      );

  Widget _body(BuildContext context, Widget textField) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.shared.filterBorderColor(context)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            if (widget.leading != null) widget.leading,
            Expanded(
              child: textField,
            ),
            if (widget.trailing != null) widget.trailing,
          ],
        ),
      );

  TextStyle _textStyle(BuildContext context, String text, double width) {
    double fontSize = 17;
    Size size;
    do {
      size = (TextPainter(
              text: TextSpan(
                  text: text,
                  style: AppTheme.shared.searchFieldPlaceholderColorTextStyle(context).copyWith(fontSize: fontSize)),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

      fontSize -= 0.5;
    } while (size.width > width);

    return AppTheme.shared.searchFieldPlaceholderColorTextStyle(context).copyWith(fontSize: fontSize);
  }
}
