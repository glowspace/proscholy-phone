import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/news_items.dart';
import 'package:zpevnik/utils/url_launcher.dart';

const double _newsItemHeight = 32;

class NewsSection extends ConsumerStatefulWidget {
  const NewsSection({super.key});

  @override
  ConsumerState<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends ConsumerState<NewsSection> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final newsItems = ref.watch(newsItemsProvider);

    if (newsItems.isEmpty) return const SizedBox();

    return Section(
      insideTitle: 'NOVINKY',
      insideTitleIcon: Icons.info_outline,
      insideTitleIconColor: yellow,
      padding: const EdgeInsets.all(kDefaultPadding).copyWith(bottom: kDefaultPadding / 2),
      margin: const EdgeInsets.symmetric(vertical: 2 / 3 * kDefaultPadding),
      children: [
        SizedBox(
          height: _newsItemHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: newsItems.length,
            itemBuilder: (_, index) => Highlightable(
              padding: EdgeInsets.zero,
              onTap: newsItems[index].hasLink ? () => launch(newsItems[index].preparedLink) : null,
              child: Row(children: [
                Text(newsItems[index].text),
                if (newsItems[index].hasLink)
                  const Padding(
                    padding: EdgeInsets.only(left: kDefaultPadding / 2),
                    child: Icon(Icons.open_in_new, size: 20),
                  )
              ]),
            ),
          ),
        ),
        if (newsItems.isNotEmpty)
          Row(children: [
            for (int i = 0; i < newsItems.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Highlightable(
                  highlightBackground: true,
                  onTap: () =>
                      _pageController.animateToPage(i, duration: kDefaultAnimationDuration, curve: Curves.easeInOut),
                  child: ListenableBuilder(
                    listenable: _pageController,
                    builder: (_, __) => Container(
                      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                      width: 24,
                      height: 2,
                      color: yellow.withAlpha((_pageController.page?.round() ?? 0) == i ? 0xff : 0x40),
                    ),
                  ),
                ),
              ),
          ]),
      ],
    );
  }
}
