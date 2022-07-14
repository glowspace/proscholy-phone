import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';

const double _newsItemHeight = 18;

class NewsSection extends StatefulWidget {
  const NewsSection({Key? key}) : super(key: key);

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final newsItems = context.watch<DataProvider>().newsItems;

    return Section(
      padding: const EdgeInsets.all(kDefaultPadding),
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
          if (newsItems.isEmpty)
            Text('Žádné novinky', style: textTheme.bodyMedium)
          else
            SizedBox(
              height: _newsItemHeight,
              child: PageView.builder(
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: newsItems.length,
                itemBuilder: (_, index) => Highlightable(
                  onTap: () => launchUrl(Uri.parse(newsItems[index].link)),
                  child: Text(newsItems[index].text, style: textTheme.bodyMedium),
                ),
              ),
            ),
          if (newsItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(top: kDefaultPadding / 2),
              child: Row(
                children: List.generate(
                  newsItems.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 24,
                    height: 2,
                    color: yellow.withAlpha(_currentIndex == index ? 0xff : 0x40),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
