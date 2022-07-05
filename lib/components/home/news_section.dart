import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final newsItems = context.watch<DataProvider>().newsItems;

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: yellow),
              const SizedBox(width: kDefaultPadding),
              Text('Novinky', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          ...newsItems.map(
            (newsItem) => Highlightable(
              onTap: () => launchUrlString(newsItem.link),
              child: Text(newsItem.text, style: textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
