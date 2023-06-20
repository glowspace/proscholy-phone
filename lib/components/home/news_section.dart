import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/news_items.dart';
import 'package:zpevnik/utils/url_launcher.dart';

const double _newsItemHeight = 18;

class NewsSection extends ConsumerStatefulWidget {
  const NewsSection({super.key});

  @override
  ConsumerState<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends ConsumerState<NewsSection> {
  final _pageController = PageController(initialPage: 0);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final newsItems = ref.watch(newsItemsProvider);

    return Section(
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
      margin: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: yellow),
              const SizedBox(width: kDefaultPadding),
              Text('Novinky', style: textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          if (newsItems.isEmpty)
            Container(
              padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
              child: Text('Žádné novinky', style: textTheme.bodyMedium),
            )
          else
            SizedBox(
              height: _newsItemHeight,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: newsItems.length,
                itemBuilder: (_, index) => HighlightableTextButton(
                  onTap: () => launch(context, newsItems[index].link),
                  child: Text(newsItems[index].text),
                ),
              ),
            ),
          if (newsItems.isNotEmpty)
            Row(
              children: List.generate(
                newsItems.length,
                (index) => InkWell(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: kDefaultAnimationDuration,
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
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
