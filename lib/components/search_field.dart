import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class SearchField extends StatefulWidget {
  final bool isInsideSearchScreen;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const SearchField({Key? key, this.isInsideSearchScreen = false, this.onChanged, this.onSubmitted}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();

    // autofocus on search screen
    if (widget.isInsideSearchScreen) {
      Future.delayed(const Duration(milliseconds: 10), () => _requestFocusAfterTransition());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? suffixIcon;
    if (widget.isInsideSearchScreen) {
      suffixIcon = Highlightable(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: const Icon(Icons.clear),
        onTap: _clearOrPop,
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
            fillColor: theme.colorScheme.surface,
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
          onTap: _showSearchScreen,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  void _showSearchScreen() {
    if (widget.isInsideSearchScreen) return;

    // prevent keyboard from showing up
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pushNamed('/search');
  }

  void _clearOrPop() {
    if (_controller.text.isEmpty) {
      Navigator.of(context).pop();
    } else {
      _controller.clear();
      widget.onChanged?.call('');
    }
  }

  // requests focus after route transition ends, needed becuse of the hero transition of searchfield
  void _requestFocusAfterTransition() {
    final animation = ModalRoute.of(context)?.animation;

    void handler(status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 10), () => FocusScope.of(context).requestFocus(_focusNode));

        animation?.removeStatusListener(handler);
      }
    }

    animation?.addStatusListener(handler);
  }
}
