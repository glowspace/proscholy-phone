import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class BottomFormSheet extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const BottomFormSheet({Key key, this.title, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Container(
                  padding: EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
                  child: Text(title, style: Theme.of(context).textTheme.headline6),
                ),
              for (final item in items) item
            ],
          ),
        ),
      );
}
