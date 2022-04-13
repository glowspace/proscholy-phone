import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class BottomFormSheet extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Widget? bottomAction;
  final EdgeInsets contentPadding;

  const BottomFormSheet({
    Key? key,
    required this.title,
    this.items = const [],
    this.bottomAction,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: check if it can actually be empty
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(title, style: AppTheme.of(context).titleTextStyle),
            ),
          const SizedBox(height: kDefaultPadding),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: contentPadding,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: items),
              ),
            ),
          ),
          if (bottomAction != null) bottomAction!,
        ],
      ),
    );
  }
}
