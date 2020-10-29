import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/screens/filters/section.dart';

class FiltersWidget extends StatelessWidget {
  FiltersWidget({key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            child: Consumer<TagsProvider>(
              builder: (context, provider, _) => Column(
                children: provider.tags.entries
                    .map((entry) =>
                        FiltersSection(title: entry.key, tags: entry.value))
                    .toList(),
              ),
            ),
          ),
        ),
      );
}
