import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/song_lyric/utils/utils.dart';
import 'package:zpevnik/theme.dart';

class SearchField extends StatefulWidget {
  final String placeholder;
  final FocusNode? focusNode;
  final Function(String) onSearch;
  final Function(String)? onSubmitted;

  final Widget? prefix;
  final Widget? suffix;

  const SearchField({
    Key? key,
    this.placeholder = '',
    this.focusNode,
    required this.onSearch,
    this.onSubmitted,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> with PlatformMixin {
  final _textController = TextEditingController();

  @override
  initState() {
    super.initState();

    _textController.text = PageStorage.of(context)?.readState(context) as String? ?? '';
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextField(
        key: PageStorageKey(widget.key.toString() + '_text_field'),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.placeholder,
          hintStyle: _placeholderStyle(context, constraints.maxWidth),
          suffixIcon: _textController.text.isEmpty
              ? null
              : Highlightable(
                  onPressed: () {
                    setState(() => _textController.clear());

                    _searchTextChanged('');
                  },
                  child: Icon(Icons.clear, size: kDefaultPadding),
                  padding: EdgeInsets.zero,
                ),
          suffixIconConstraints: BoxConstraints(),
        ),
        focusNode: widget.focusNode,
        controller: _textController,
        onChanged: _searchTextChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CupertinoTextField(
        key: PageStorageKey(widget.key.toString() + '_text_field'),
        controller: _textController,
        decoration: BoxDecoration(color: Colors.transparent),
        focusNode: widget.focusNode,
        placeholder: widget.placeholder,
        placeholderStyle: _placeholderStyle(context, constraints.maxWidth),
        onChanged: _searchTextChanged,
        onSubmitted: widget.onSubmitted,
        clearButtonMode: OverlayVisibilityMode.editing,
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      ),
    );
  }

  @override
  Widget buildWrapper(BuildContext context, Widget Function(BuildContext) builder) {
    final appTheme = AppTheme.of(context);

    return Container(
      height: 44,
      padding: EdgeInsets.only(
        left: widget.prefix == null ? kDefaultPadding : 0,
        right: widget.suffix == null ? kDefaultPadding : 0,
      ),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        border: Border.all(color: appTheme.borderColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(children: [
        if (widget.prefix != null) widget.prefix!,
        Expanded(child: builder(context)),
        if (widget.suffix != null) widget.suffix!,
      ]),
    );
  }

  void _searchTextChanged(String searchText) {
    // store current searchText to keep it persistent between tab changes
    PageStorage.of(context)?.writeState(context, searchText);

    widget.onSearch(searchText);
  }

  TextStyle? _placeholderStyle(BuildContext context, double width) {
    TextStyle? textStyle = AppTheme.of(context).placeholderTextStyle;
    if (textStyle == null) return null;

    double fontSize = textStyle.fontSize ?? 0;

    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    while (true) {
      textStyle = textStyle?.copyWith(fontSize: fontSize);
      fontSize -= 0.1;

      final placeholderWidth = computeTextWidth(widget.placeholder, textStyle: textStyle, scaleFactor: scaleFactor);

      if (placeholderWidth < width) return textStyle;
    }
  }
}
