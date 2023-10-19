import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/extensions.dart';

class SearchFieldTransitionWidget extends AnimatedWidget {
  final Animation<double> animation;

  const SearchFieldTransitionWidget({
    super.key,
    required this.animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fillColor = ColorTween(
      begin: theme.colorScheme.surface,
      end: theme.brightness.isLight ? theme.scaffoldBackgroundColor : theme.colorScheme.surface,
    ).evaluate(animation);

    return Container(
      padding: EdgeInsets.only(left: animation.value * kDefaultPadding),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Název, číslo nebo část textu',
                  hintStyle: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: theme.brightness.isLight ? lightIconColor : darkIconColor,
                  ),
                  filled: true,
                  fillColor: fillColor,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: Opacity(
                opacity: animation.value,
                child: Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text('Zrušit', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  final bool isInsideSearchScreen;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const SearchField({super.key, this.isInsideSearchScreen = false, this.onChanged, this.onSubmitted});

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
        onTap: _clearOrPop,
        icon: const Icon(Icons.clear),
      );
    }

    return Hero(
      tag: 'search',
      flightShuttleBuilder: MediaQuery.of(context).isTablet
          ? null
          : (_, animation, __, ___, ____) => SearchFieldTransitionWidget(animation: animation),
      child: Container(
        padding: widget.isInsideSearchScreen ? const EdgeInsets.only(left: kDefaultPadding) : null,
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (_, value, __) => TextField(
                    decoration: InputDecoration(
                      hintText: 'Název, číslo nebo část textu',
                      hintStyle: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.brightness.isLight ? lightIconColor : darkIconColor,
                      ),
                      filled: true,
                      fillColor: theme.brightness.isLight && widget.isInsideSearchScreen
                          ? theme.scaffoldBackgroundColor
                          : theme.colorScheme.surface,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(kDefaultRadius),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: Icon(Icons.search, color: theme.iconTheme.color),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      suffixIcon: value.text.isEmpty ? null : suffixIcon,
                      suffixIconConstraints: const BoxConstraints(),
                      contentPadding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    ),
                    // disable pasting to search field on home screen, as it should only open search screen
                    enableInteractiveSelection: widget.isInsideSearchScreen,
                    onTap: _showSearchScreen,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    controller: _controller,
                    focusNode: _focusNode,
                  ),
                ),
              ),
              if (widget.isInsideSearchScreen)
                Highlightable(
                  onTap: () => context.maybePop(),
                  padding: const EdgeInsets.all(kDefaultPadding),
                  textStyle: theme.textTheme.bodyMedium,
                  foregroundColor: theme.colorScheme.primary,
                  child: const Text('Zrušit'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchScreen() {
    if (widget.isInsideSearchScreen) return;

    // prevent keyboard from showing up
    FocusScope.of(context).requestFocus(FocusNode());

    context.push('/search');
  }

  void _clearOrPop() {
    if (_controller.text.isEmpty) {
      context.maybePop();
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
