import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class SearchField extends StatelessWidget {
  final bool isInsideSearchScreen;

  SearchField({Key? key, this.isInsideSearchScreen = false}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? suffixIcon;
    if (isInsideSearchScreen) {
      suffixIcon = Highlightable(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: const Icon(Icons.clear),
        ),
        onTap: () => _clearOrPop(context),
      );
    }

    return Hero(
      tag: 'search',
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Hledat název, číslo nebo část textu',
            filled: true,
            fillColor: theme.backgroundColor,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: const Icon(Icons.search),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(),
            contentPadding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          ),
          onTap: () => _showSearchScreen(context),
          controller: _controller,
        ),
      ),
    );
  }

  void _showSearchScreen(BuildContext context) {
    if (isInsideSearchScreen) return;

    // prevent keyboard from showing up
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pushNamed('/search');
  }

  void _clearOrPop(BuildContext context) {
    if (_controller.text.isEmpty) {
      Navigator.of(context).pop();
    } else {
      _controller.clear();
    }
  }
}
